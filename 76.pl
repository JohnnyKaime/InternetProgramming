#!/usr/bin/perl -w

use strict;
use warnings;
my $userIn = <STDIN>;
chomp($userIn);

opendir(DIR, "ex5Dir") or die "Directory does not exist: $!";
my @newArr = readdir(DIR);
chdir("ex5Dir");
shift(@newArr);
shift(@newArr);

while($#newArr >= 0)
{
	#print ">>> ", @newArr, "\n";
	#while($target == ""){pop(@newArr);}
	my $target = pop(@newArr);
	#chomp($target);
	#print "popping |", $target, "|\n";

	if(-d $target)
	{
		#print "FOLDER:[", $target, "]\n";
		# print "dirSec\n";
		opendir(DIR2, $target);
		my @decoyArr = readdir(DIR2);

		# print "retireved: ", @decoyArr, "\n";
		closedir(DIR2);
		#print ">> ", $#decoyArr, "\n";

		for(my $i = 0; $i < scalar(@decoyArr); $i++)
		{
			if($decoyArr[$i] eq "."  || $decoyArr[$i] eq "..")
			{
				$decoyArr[$i] = "";
			}
			else{$decoyArr[$i] = $target . "/" . $decoyArr[$i]}
		}
		if($#decoyArr > 1){
			push(@newArr, @decoyArr); 
			# print @newArr, "<-\n";
		}
	}
	elsif($target =~ /$userIn$/){
		print "Found [", $target, "]\n";
	}
}

closedir(DIR);
#system("pause");
