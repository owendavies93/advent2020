#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(reduce);

chomp(my ($ts, $ids) = <>);

my @factors = split ',', $ids;
my @with_indices;

for (my $i = 0; $i < @factors; $i++) {
    my $f = $factors[$i];
    next if $f eq 'x';
    push @with_indices, {
        factor => $f,
        index  => $i,
    };
}

my $final_factor = reduce {
    my $index = $a->{index};

    while (($index + $b->{index}) % $b->{factor} != 0) {
        $index += $a->{factor};   
    }

    {
        factor => $a->{factor} * $b->{factor},
        index  => $index,
    }
} @with_indices;

print $final_factor->{index} . "\n";

