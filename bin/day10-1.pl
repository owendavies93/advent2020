#!/usr/bin/env perl

use strict;
use warnings;

chomp(my @lines = <>);

my @sort = sort { $a <=> $b } @lines;

my $diffs = {
    1 => 1,
    3 => 1,    
};

for (my $i = 1; $i < @sort; $i++) {
    my $diff = $sort[$i] - $sort[$i - 1];

    if ($diffs->{$diff}) {
        $diffs->{$diff}++;
    } else {
        $diffs->{$diff} = 1;
    }
}

print $diffs->{1} * $diffs->{3} . "\n";

