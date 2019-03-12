#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

my $script = new CGI;
my $submit = $script->param('confirm');
my $find = $script->param('search');
my $improved = $find;
$improved =~ s/\s/%20/g;
undef $/;

my $fname = 'page.html';
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
		if($counter != 50){
			next if $url =~ /yahoo/;
			next if $url =~ /localhost/;
			$nurllist[$#nurllist+1] = $url;
			$counter++;
		}
	}
	return( \@nurllist );
}

sub yahoo{
	my $query="https://za.search.yahoo.com/search?p=".$improved;
	print `wget $query -O yahoo-search.html`;
	my $find_urls = `lynx -dump yahoo-search.html`;
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
		if($counter != 50){
			next if $url =~ /yahoo/;
			next if $url =~ /localhost/;
			$nurllist[$#nurllist+1] = $url;
			$counter++;
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
	    if($counter != 50){
			next if $url =~ /yahoo/;
			next if $url =~ /localhost/;
			$nurllist[$#nurllist+1] = $url;
			$counter++;
		}
	}
	return( \@nurllist );
}
my $copy=$template;
my $outStr;

sub cleanPrint{
	my ($result,$name) = @_;
	my @test = @$result;
	my %hash   = map { $_ => 1 } @test;
	my @unique = keys %hash;
	$outStr .= "<h2>Results from : $name</h2>";
	for my $ind(@unique){
		$outStr = $outStr. "<a href=$ind>".$ind."</a></br>";
	}
}

if(defined $submit)
{
	cleanPrint(duckGo,"DuckDuckGo");
	cleanPrint(yahoo,"Yahoo");
	cleanPrint(bing,"Bing");
	#my $duckResult = duckGo();
	#my @test = @$duckResult;
	#my %hash   = map { $_ => 1 } @test;
	#my @unique = keys %hash;
	#my $yahooResult = yahoo();
	#my @test2 = @$yahooResult;
	#my %hash   = map { $_ => 1 } @test2;
	#my @unique2 = keys %hash;
	#my $bingResult = bing();	
	#my @test3 = @$bingResult;
	#my %hash   = map { $_ => 1 } @test3;
	#my @unique3 = keys %hash;

	#$outStr = "<h2>Results from DuckDuckGo:</h2>";
	#for my $ind(@unique){
		#$outStr = $outStr. "<a href=$ind>".$ind."</a></br>";
	#}
	#$outStr .= "<h2>Results from Yahoo:</h2>";
	#for my $ind(@unique2){
		#$outStr = $outStr. "<a href=$ind>".$ind."</a></br>";
	#}
	#$outStr .= "<h2>Results from Bing:</h2>";
	#for my $ind(@unique3){
		#$outStr = $outStr. "<a href=$ind>".$ind."</a></br>";
	#}
	$copy =~ s/<!--Text-->/$outStr/s;
}
$copy =~ s/<!--Search-->/$find/s;
print $script->header( -Cache_Control => 'private' );
print $copy;
