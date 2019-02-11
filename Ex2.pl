#Jia-Cong Hou
#3565155
#Internet Programming
#Exercise 2

use strict;
use warnings;

print "Please enter numbers then please the enter key.\n";

my %hashTable;

$hashTable{<STDIN>} = <STDIN>;
$hashTable{<STDIN>} = <STDIN>;
$hashTable{<STDIN>} = <STDIN>;
$hashTable{<STDIN>} = <STDIN>;

my $val1 = $hashTable{<STDIN>} + $hashTable{<STDIN>};
my $val2 = $hashTable{<STDIN>} + $hashTable{<STDIN>};

if($val1 > $val2){
	print STDOUT $val1;
}else{
	print STDOUT $val2;
}

print "\n";
#system("pause");

