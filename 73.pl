use strict;
use warnings;

my $count = 1;
my @files = <*>;

foreach(@files){
	my $newFile = "$count".".fil";
	rename($_,"$newFile");
	$count++;
}
system("pause");