#!/usr/bin/perl

use strict;
use warnings;

my %wordHash;
chomp(my $key = <STDIN>);

while($key ne "DONE"){
	#or ' ' works to split all white spaces
	my @input = split /\s+/ , $key;
	foreach $key (@input){
		if (exists $wordHash{$key}){
			$wordHash{$key}++;
		}else{
			$wordHash{$key} = 1;
		}
	}
	chomp($key = <STDIN>);
}

foreach my $keys (keys %wordHash){
    print STDOUT $keys," -> ",$wordHash{$keys},"\n";
}

system("pause");
