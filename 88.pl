#!/usr/bin/perl
use warnings;
use strict;

print "Using loops: Input power of e\n";
my $base = 10;
my $power = <STDIN>;
my $sum = 1;

for(my $i = $base-1; $i>0; --$i){
	$sum = 1 + $power * $sum / $i;
}
print $sum, "\n";

print "Using subroutines: Input base then power of: \n";
my $pow = <STDIN>;
my $loops = 100;

sub expon{
    my ($i) = @_;
    if($i == 0){
        return 1;}
    else{
        return ($pow ** $i / fact($i)) + expon($i-1);
    }
    
}

sub fact{
    my ($num) = @_;
    if($num != 0){
        return $num * fact($num-1);
    }else{
        return 1;
    }
}

print expon($loops),"\n";
system("pause");
