#!/usr/bin/perl

use strict;
use warnings;

my @largeListOfJunk;

print "Type in junk, enter DONE when finihsed.\n";

sub merge1{
	my ($value) = @_;
	if($value ne "DONE"){
		push(@largeListOfJunk,$value);
		if(chomp(my $input = <STDIN>) ne "DONE"){
			merge2($input);
		}
	}
	return;
}

sub merge2{
	my ($value) = @_;
	if($value ne "DONE"){
		push(@largeListOfJunk,$value);
		if(chomp(my $input = <STDIN>) ne "DONE"){
			merge1($input);
		}
	}
	return;
}

merge1("\nSTARTo\n");

print @largeListOfJunk;
system("pause");
