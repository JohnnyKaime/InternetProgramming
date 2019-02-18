use strict;
use warnings;

foreach my $forward (1..7){
	print '* ' x $forward, "\n";
}
print"\n";
foreach my $forward (reverse 1..7){
	print '* ' x $forward, "\n";
}
print"\n";
my $count1 = 1;
foreach my $forward (reverse 0..6){
	print '  ' x $forward, "* " x $count1++, "\n";
}
print "\n";
my $count2 = 7;
foreach my $forward (0..6){
	print '  ' x $forward, "* " x $count2--, "\n";
}

my $stars = 1;
my $jump = 4;
foreach my $forward (1..5){
	print '  ' x $jump, "* " x $stars, "  " x $jump--, "\n";
	$stars+=2;
}
$stars = 7;
$jump = 1;
foreach my $forward (reverse 1..4){
	print '  ' x $jump, "* " x $stars, "  " x $jump++, "\n";
	$stars-=2;
}

system("pause");
