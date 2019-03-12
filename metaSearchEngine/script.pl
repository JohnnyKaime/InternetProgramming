#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

my $script = new CGI;
my $submit = $script->param('confirm');
my $find = $script->param('search');
my $improved = $find;
$improved =~ s/\s/%20/g;
my %rankHash;
undef $/;

my $fname = 'page.html';
open( FILE, "< $fname" ) or die "Could not open $fname";
my $template = <FILE>;
close( FILE );
my @test;
my $dup;
my $dup2;
sub duckGo{
	my $query="https://duckduckgo.com/html/?q=".$improved;
	print `wget $query -O duckduckgo-search.html`;
	my $find_urls = `lynx -dump duckduckgo-search.html`;
	$dup = $find_urls;
	$dup2 = $find_urls;
	$dup2 =~ /[1](.*?)[2]/; 
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
	my @clean = @$result;
	my %hash   = map { $_ => 1 } @clean;
	my @unique = keys %hash;
	$outStr .= "<h2>Results from : $name</h2>";
	for my $ind(@unique){
		$ind =~ s/%2F/\//g;
		$ind =~ s/%3A/:/g;
		chomp($ind);
		$outStr = $outStr. "<a href=$ind>".$ind."</a></br>";
		if (exists $rankHash{"<a href=$ind>".$ind."</a>"}) {
			$rankHash{"<a href=$ind>".$ind."</a>"}++;
		} else {
			$rankHash{"<a href=$ind>".$ind."</a>"} = 1;
		}
	}
}

if(defined $submit)
{
	cleanPrint(duckGo,"DuckDuckGo");
	cleanPrint(yahoo,"Yahoo");
	cleanPrint(bing,"Bing");
	$copy =~ s/<!--Text-->/$outStr/s;
}
$copy =~ s/<!--Search-->/$find/s;
print $script->header( -Cache_Control => 'private' );
print $copy;
print "<h2>After Ranking</h2>";
print "<h3>First 20 links with most appearances</h3>";
my $counter = 20;
foreach my $name (reverse sort { $rankHash{$a} <=> $rankHash{$b}} keys %rankHash) {
	if($counter != 0){
		print $name."  Appearances  ".$rankHash{$name}."</br>";
		$counter--
	}else{last;}
}
print "<h4>Test Description</h4>";
print "<p>$dup</p>";
print "<h4>Test Description after shit happens</h4>";
print "<p>$dup2</p>"
