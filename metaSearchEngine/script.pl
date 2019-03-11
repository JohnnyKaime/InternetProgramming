#!/usr/bin/perl -w

# time to code all three (including findind search engines to scrape):  1 hour 7 minutes

use strict;
use warnings;
use CGI;

my $script = new CGI;
my $submit = $script->param('confirm');
my $find = $script->param('search');
my $improved = $find;
$improved =~ s/\s/%20/g;
undef $/;

my $fname = 'metaPage.html';
open( FILE, "< $fname" ) or die "Could not open $fname";
my $template = <FILE>;
close( FILE );


sub duckGo{
	my $query="https://duckduckgo.com/html/?q=".$improved;
	print `wget $query -O duckduckgo-search.html`;
	my $find_urls = `lynx -dump duckduckgo-search.html`;
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
	    next if $url =~ /duckduckgo/;
	    next if $url =~ /localhost/;
	    $nurllist[$#nurllist+1] = $url;
	    $counter++;
	    if($counter==20){
	    	last;
	    }
	}
	return( \@nurllist );
}

sub ask{
	my $query="http://www.ask.com/web?q=".$improved;
	print `wget $query -O ask-search.html`;
	my $find_urls = `lynx -dump ask-search.html`;
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
	    next if $url =~ /ask/;
	    next if $url =~ /localhost/;
	    $nurllist[$#nurllist+1] = $url;
	    $counter++;
	    if($counter==20){
	    	last;
	    }
	}
	return( \@nurllist );
}

sub bing{
	my $query="https://www.bing.com/search?q=".$improved;
	print `wget $query -O bing-search.html`;
	my $find_urls = `lynx -dump bing-search.html`;
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
	    next if $url =~ /bing/;
	    next if $url =~ /localhost/;
	    $nurllist[$#nurllist+1] = $url;
	    $counter++;
	    if($counter==20){
	    	last;
	    }
	}
	return( \@nurllist );
}
my $copy=$template;

if(defined $submit)
{
		
	my $duckresult = duckGo();
	my $askresult = ask();
	my $bingresult = bing();	

	my $outStr = "<h2>Results from DuckDuckGo:</h2>";
	for my $ind(@$duckresult){
		$outStr = $outStr. "<a href=$ind>".$ind."</a>\n";
	}
	$outStr .= "<h2>Results from Ask:</h2>";
	for my $ind(@$askresult){
		$outStr = $outStr. "<a href=$ind>".$ind."</a>\n";
	}
	$outStr .= "<h2>Results from Bing:</h2>";
	for my $ind(@$bingresult){
		$outStr = $outStr. "<a href=$ind>".$ind."</a>\n";
	}
	$copy =~ s/<!--Text-->/$outStr/s;
}
$copy =~ s/<!--Search-->/$find/s;
print $script->header( -Cache_Control => 'private' );
print $copy;
