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
const my $DAYS => 100;

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

my @init_black = grep { $result->{$_} % 2 == 1 } keys %$result; 
my $is_black = {}; 
$is_black->{$_} = 1 for @init_black;
my $total = scalar @init_black;

my $counts = _update_state($is_black);

for (1..$DAYS) {
    my $new = {};

    foreach my $t (keys %$counts) {
        if ($is_black->{$t}) {
            if ($counts->{$t} == 0 || $counts->{$t} > 2) {
                $is_black->{$t} = 0;
                $total--;   
            }
        } else {
            if ($counts->{$t} == 2) {
                $is_black->{$t} = 1;
                $total++;
            }
        }
    }

    $counts = _update_state($is_black);
}

say $total;

sub _update_state {
    my $is_black = shift;

    my $counts = {};

    foreach my $i (keys %$is_black) {
        next if $is_black->{$i} == 0;
        
        $counts->{$i} //= 0;

        my ($x, $y) = split ',', $i;
        foreach my $n (_neighbours($x, $y)) {
            $counts->{_key($n->[0], $n->[1])}++;        
        }
    }

    return $counts;
}

sub _key {
    my ($x, $y) = @_;
    return "$x,$y";
}

sub _neighbours {
    my ($x, $y) = @_;
    return map { [
        $x + $MOVE_DIRS->{$_}->[0],
        $y + $MOVE_DIRS->{$_}->[1],
    ] } keys %$MOVE_DIRS;
}
