use strict;
use warnings;

my $dir="/mnt/c/Users/johnn/Desktop/Internet\ Programming";
opendir (DIR, $dir) or die $!;
while (my $file_name = readdir(DIR)){
	print "$file_name\n";
}
closedir(DIR);
system("pause");