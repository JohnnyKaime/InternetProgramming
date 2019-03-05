#! /usr/bin/perl -w

use strict;
use warnings;
use CGI;
undef $/;

my %messageHash;
my $fileName = 'messages.txt';
open(my $fh, '+<', $fileName) or die "Could not open $fileName";

while(my $row = <$fh>){
	print $row;
	print "\nend of row\n";
	my @row = split('>>',$row);
	
	$messageHash{$row[0]} = $row[1];
}
close($fh);
foreach my $key (keys %messageHash){
	print $key," ",$messageHash{$key};
}


#my $webfile = '212.html';
#open( FILE, "< $webfile" ) or die "Could not open $webfile";
#my $template = <FILE>;
#close( FILE );

