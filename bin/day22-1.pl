#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

my @p1;
my @p2;
while (<>) {
    chomp;

    next if /Player/;
    last if !$_;

    push @p1, $_;
}

while (<>) {
    chomp;

    next if /Player/;

    push @p2, $_;
}

while (@p1 > 0 && @p2 > 0) {
    my $c1 = shift @p1;
    my $c2 = shift @p2;

    if ($c1 > $c2) {
        push @p1, $c1;
        push @p1, $c2;
    } else {
        push @p2, $c2;
        push @p2, $c1;
    }
}

say @p1 > 0 ? _score(@p1) : _score(@p2);

sub _score {
    my @pack = @_;

    my $len = scalar @pack;
    my $score = 0;
    for (@pack) {
        $score += ($_ * $len--);
    }

    return $score;
}

