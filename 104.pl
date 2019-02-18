#Jia-Cong Hou
#3565155
#Internet Programming
#Exercise P104

#!/usr/bin/perl
use warnings;
use strict;
 
my $string = "JohnnyKaime wasn't here\n";
 
my $filename = 'DefinitelyNotJohnny';
 
open(FH, '>', $filename) or die $!;

print "Enter junk to store my name :D\nEnter DONE to stop\n";
chomp(my $input = <STDIN>);
do{
	print FH $string;
	chomp( $input = <STDIN>);
}while($input ne "DONE");

seek(FH, 0, 0);
print FH "DefinitelyNotFirstLine!!!:3\n\n";
close(FH);
 
print "Writing to file successfully!\n";

system("pause");
