#!/usr/bin/env/perl

use strict;
use warnings;

use Const::Fast;
use v5.10;

use List::AllUtils qw(any firstidx max);

const my $INPUT => "186524973";
const my $MAX   => 1_000_000;
const my $MOVES => 10_000_000;

my @cups = map { { val => $_ } } (split '', $INPUT);
my $top = scalar @cups;

for (my $i = $top + 1; $i <= $MAX; $i++) {
    push @cups, { val => $i };
}

for (my $i = 0; $i < $MAX; $i++) {
    my $c = $cups[$i];

    if ($i < $MAX - 1) {
        $c->{next} = $cups[$i + 1];
    } else {
        $c->{next} = $cups[0];
    }
}

my $vals = {};
for my $cup (@cups) {
    $vals->{$cup->{val}} = $cup;
}

my $curr = $cups[0];
for (1..$MOVES) {
    my @pick_up = (
        $curr->{next}->{val},
        $curr->{next}->{next}->{val},
        $curr->{next}->{next}->{next}->{val}
    );

    my $first = $curr->{next};
    $curr->{next} = $curr->{next}->{next}->{next}->{next};

    my $new = $curr->{val} - 1;

    while (any { $_ eq $new } @pick_up) {
        $new = $new == 0 ? $MAX : $new - 1;
    }

    $new = $MAX if $new == 0;

    my $c = $vals->{$new};
    $first->{next}->{next}->{next} = $c->{next};
    $c->{next} = $first;
    
    $curr = $curr->{next};
}

my $one = $vals->{1};
say $one->{next}->{val} * $one->{next}->{next}->{val};

