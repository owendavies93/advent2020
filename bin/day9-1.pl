#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib';

use Advent2020::Utils qw(find_sum_pair);

use Const::Fast;

const my $PREAMBLE => 25;

chomp(my @lines = <>);

my $len = scalar @lines;

for (my $i = $PREAMBLE; $i <= $len; $i++) {
    my $candidate = $lines[$i];
    my $found = find_sum_pair($candidate, @lines[($i - $PREAMBLE)..($i - 1)]);

    if (!$found) {
        print $candidate . "\n";
        last;
    }
}

