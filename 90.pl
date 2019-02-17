use strict;
use warnings;

my $max = 1000;
my @primes;
my @notprime;
for my $num (2..$max) {
    next if $notprime[$num];
    push @primes, $num;
    for (my $multiple = 2 * $num; $multiple <= $max; $multiple += $num) {
        $notprime[$multiple] = 1;
    }
}
print join("\n",@primes);

sytem("pause");