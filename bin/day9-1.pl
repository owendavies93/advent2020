#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Const::Fast;

const my $PREAMBLE => 25;

chomp(my @lines = <>);

my $len = scalar @lines;

for (my $i = $PREAMBLE; $i <= $len; $i++) {
    my $candidate = $lines[$i];
    my $found = _find_sum_pair($candidate, @lines[($i - $PREAMBLE)..($i - 1)]);

    if (!$found) {
        print $candidate . "\n";
        last;
    }
}

sub _find_sum_pair {
    my ($candidate, @nums) = @_;

    my @sorted = sort { $a <=> $b } @nums;

    my $a = 0;
    my $b = $PREAMBLE - 1;

    while ($a < $b) {
        my $sum = $sorted[$a] + $sorted[$b];

        if ($sum == $candidate) {
            return $candidate;
        }

        if ($sum < $candidate) {
            $a++;
        } else {
            $b--;
        }
    }

    return 0;
}

