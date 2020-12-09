#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max min);

chomp(my @lines = <>);

my $a = 0;
my $b = 0;
my $sum = $lines[0];
my $target = 1504371145;

while ($sum != $target) {
    if ($sum > $target) {
        $sum -= $lines[$a++];
    } elsif ($sum < $target) {
        $sum += $lines[++$b];
    }
}

my @range = @lines[$a..$b];

print min(@range) + max(@range) . "\n";

