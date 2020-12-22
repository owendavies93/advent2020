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

say _game(0, \@p1, \@p2);

sub _game {
    my ($i, $p1, $p2) = @_;

    my $jes_cache = {};

    while (@$p1 > 0 && @$p2 > 0) {
        my $cache_key = _key($p1, $p2);
        return 1 if exists $jes_cache->{$cache_key};

        $jes_cache->{$cache_key}++;

        my $c1 = shift @$p1;
        my $c2 = shift @$p2;
        
        my $sub_game_winner;
        if ($c1 <= scalar @$p1 && $c2 <= scalar @$p2) {
            my @copy1 = map { $p1->[$_] } (0..$c1 - 1);
            my @copy2 = map { $p2->[$_] } (0..$c2 - 1);

            $sub_game_winner = _game($i + 1, \@copy1, \@copy2);
        } else {
            $sub_game_winner = $c1 > $c2 ? 1 : 2;
        }

        if ($sub_game_winner == 1) {
            push @$p1, $c1;
            push @$p1, $c2;
        } else {
            push @$p2, $c2;
            push @$p2, $c1;
        }
    }

    if ($i > 0) {
        return @$p1 > 0 ? 1 : 2;
    } else {
        return @$p1 > 0 ? _score(@p1) : _score(@p2);
    }
}

sub _key {
    my ($p1, $p2) = @_;

    return (join ',', @$p1) . '-' . (join ',', @$p2);
}

sub _score {
    my @pack = @_;

    my $len = scalar @pack;
    my $score = 0;
    for (@pack) {
        $score += ($_ * $len--);
    }

    return $score;
}

