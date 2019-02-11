#Jia-Cong Hou
#3565155
#Internet Programming
#Exercise 1

use strict;
use warnings;

print "Please enter numbers then please the enter key.\n";

my $num1 = <STDIN>;
my $num2 = <STDIN>;
my $val1 = $num1 + $num2;
print "$val1 \n";

$num1 = <STDIN>;
$num2 = <STDIN>;
my $val2 = $num1 + $num2;
print "$val2 \n";

if($val1 > $val2){
	print STDOUT $val1;
}else{
	print STDOUT $val2;
}
print "\n";
#system("pause");

