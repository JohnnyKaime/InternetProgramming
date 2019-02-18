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

print "Using subroutines: Input power of e\n";

chomp(my $n = <STDIN>);

sub factorial{
    my $n = shift;
    my $s=1;
    my $r=1;
    while ($s <= $n){
		$r *= $s;
		$s++;
    }
    if($n == 0){
        $r=0;
    }
    return $r;
}

sub expon{
	
	my ($x,$max_iterations) = @_;

    my $result = 1 + $x;
    my $i = 2;
    
    while ($i < $max_iterations) {

        $result += ($x ** ($i)) / (factorial($i));

        $i++;

    }
    return $result;
}

print expon($n,1000),"\n";
system("pause");
