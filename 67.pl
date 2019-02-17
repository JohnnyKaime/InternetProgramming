#Jia-Cong Hou
#3565155
#Internet Programming
#Exercise P67

use strict;
use warnings;

my %hashTable;
my @sumArray;

print "Please enter Pairs and store their value, press DONE to finish.\n";

chomp(my $key = <STDIN>);

while($key ne "DONE"){
	chomp(my $value = <STDIN>);
	$hashTable{$key} = $value;
	chomp($key = <STDIN>);
}

print "Please enter Pairs to be summed, press DONE to finish.\n";

chomp($key = <STDIN>);
while($key ne "DONE"){
	chomp(my $key2 = <STDIN>);
	push(@sumArray, $hashTable{$key} + $hashTable{$key2});
	chomp($key = <STDIN>);
}

my @sorted_sumArray = sort {$a <=> $b} @sumArray;
print join(", ",@sorted_sumArray);
print "\nHighest sum is ", $sorted_sumArray[-1];
print "\nSmallest sum is ", $sorted_sumArray[0];
system("\npause");
