#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

use Const::Fast;

const my $MOVE_DIRS => {
    e  => [1    ,  0],
    w  => [-1   ,  0],
    sw => [-0.5 ,  0.5],
    ne => [0.5  , -0.5],
    se => [0.5  ,  0.5],
    nw => [-0.5 , -0.5]
};

my $result = {};

while(<>) {
    chomp;

    my $tile_route = $_;
    my @coords = (0, 0);
    foreach my $match ($tile_route =~ m/(e|w|sw|ne|se|nw)/g) {
        $coords[0] += $MOVE_DIRS->{$match}->[0];
        $coords[1] += $MOVE_DIRS->{$match}->[1];
    }

    $result->{_key(@coords)}++;
}

say scalar grep { $result->{$_} % 2 == 1 } keys %$result; 

sub _key {
    my ($x, $y) = @_;
    return "$x,$y";
}

