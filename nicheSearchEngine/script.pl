#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use URI::Title qw( title );

my $script = new CGI;
my $submit = $script->param('confirm');
my $find = $script->param('search');
my $improved = $find;
$improved =~ s/\s/%20/g;
my %rankHash;
my %rankDescription;
undef $/;

my $fname = 'page.html';
open( FILE, "< $fname" ) or die "Could not open $fname";
my $template = <FILE>;
close( FILE );

sub formatString{
	my ($ind) = @_;
	$ind =~ s/%2F/\//g;
	$ind =~ s/%3A/:/g;
	$ind =~ s/%2D/-/g;
	$ind =~ s/%3D/=/g;
	$ind =~ s/%3F/?/g;
	$ind =~ s/%25/%/g;
	$ind =~ s/%26/&/g;
	$ind =~ s/%20/ /g;
	$ind =~ s/%28/(/g;
	$ind =~ s/%29/)/g;
	chomp($ind);
	return $ind;
}

my @test;
my $dup2;
my $dup;
sub duckGo{
	my $query="https://duckduckgo.com/html/?q=".$improved;
	print `wget $query -O duckduckgo-search.html`;
	my $find_urls = `lynx -dump duckduckgo-search.html`;
	$dup2 = $find_urls;
	$dup = $find_urls;
	while ($dup2 =~ s/\[\d+\](.*?)\[\d+\]//sm){
		$test[$#test+1] = $1;
	}
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
			$nurllist[$#nurllist+1] = formatString($url);
			$rankDescription{formatString($url)} = $test[$counter];
			$counter++;
		}else{last;}
	}
	return( \@nurllist );
}

sub yahoo{
	my $query="https://za.search.yahoo.com/search?p=".$improved;
	print `wget $query -O yahoo-search.html`;
	my $find_urls = `lynx -dump yahoo-search.html`;
	$dup2 = $find_urls;
	while ($dup2 =~ s/\[\d+\](.*?)\[\d+\]//sm){
		$test[$#test+1] = $1;
	}
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
		if($counter != 20){
			next if $url =~ /yahoo/;
			next if $url =~ /localhost/;
			$nurllist[$#nurllist+1] = formatString($url);
			$rankDescription{formatString($url)} = $test[$counter];
			$counter++;
		}else{last;}
	}
	return( \@nurllist );
}

sub bing{
	my $query="https://www.bing.com/search?q=".$improved;
	print `wget $query -O bing-search.html`;
	my $find_urls = `lynx -dump bing-search.html`;
	$dup2 = $find_urls;
	while ($dup2 =~ s/\[\d+\](.*?)\[\d+\]//sm){
		$test[$#test+1] = $1;
	}
	$find_urls =~ s/[\w\W]+Visible links//mis;

	my @urllist;
	while( $find_urls =~ s/\s*(http[^\s]+)\s*// ){
	    $urllist[$#urllist+1] = $1;
	}
	my $counter = 0;
	my @nurllist;
	foreach my $url (@urllist){
	    if($counter != 20){
			next if $url =~ /bing/;
			next if $url =~ /localhost/;
			$nurllist[$#nurllist+1] = formatString($url);
			$rankDescription{formatString($url)} = $test[$counter];
			$counter++;
		}else{last;}
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
		$outStr = $outStr. "<a href=$ind>".formatString($ind)."</a></br>";
		if (exists $rankHash{$ind}) {
			$rankHash{$ind}++;
		} else {
			$rankHash{$ind} = 1;
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
print "<h3>First 10 links with most appearances</h3>";
my $counter = 0;
foreach my $name (reverse sort { $rankHash{$a} <=> $rankHash{$b}} keys %rankHash) {
	if($counter != 10){
		my $title = title($name);
		if($title){
			print "<h4>$title</h4>";
		}else{
			print "No Title Found";
		}
		print "<a href=$name>".$name."</a>  Appearances  ".$rankHash{$name};
		print "<p>$rankDescription{$name}</p>";
		$counter++;
	}else{last;}
}

my $fsn = 'URLs.txt';
open( FILE, '>', $fsn ) or die "Could not open $fsn";
foreach my $item (keys %rankHash){
	print FILE ($item."\n");
}
close( FILE );
