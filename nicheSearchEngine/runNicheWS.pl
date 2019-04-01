#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use URI::Title qw( title );

my $script = new CGI;
my @LinksArray;
my @ResultsArray;
#undef $/;
my $fname = 'page2.html';
open( FILE, "< $fname" ) or die "Could not open $fname";
my $template;
while(my $line = <FILE>){
	$template = $template.$line;
}
close( FILE );
my $copy = $template;

my $links = 'URLs.txt';
open( FILE, "< $links" ) or die "Could not open $links";
while(my $line = <FILE>){
	chomp $line;
	push(@LinksArray,$line)
}
close( FILE );

my $Rlinks = 'temp';
open( FILE, "< $Rlinks" ) or die "Could not open $Rlinks";
while(my $line = <FILE>){
	chomp $line;
	push(@ResultsArray,$line)
}
close( FILE );

my $count = @LinksArray;
my $index = 0;

my $string1 = "";
my $string2 = "";

while($index != $count){
	my $tempLink = $LinksArray[$index];
	my $title = title("$tempLink");
	#print $title;
	if(int($ResultsArray[$index]) == 1){
		$string1 = $string1."<h4>$title</h4><a href=$tempLink>".$tempLink."</a></br>";
		#$string1 = $string1."<a href=$tempLink>".$tempLink."</a><br.>";
	}else{
		$string2 = $string2."<h4>$title</h4><a href=$tempLink>".$tempLink."</a></br>";
		#$string1 = $string1."<a href=$tempLink>".$tempLink."</a><br.>";
	}
	$index++;
}
$copy =~ s/<!--Text1-->/$string1/s;
$copy =~ s/<!--Text2-->/$string2/s;

print $script->header( -Cache_Control => 'private' );
print $copy;