#!/usr/bin/env/perl

use strict;
use warnings;

use v5.10;

use lib '../lib';

use List::Util qw(uniq);
use Advent2020::Utils qw(read_into_2d_array);

my $tiles = {};
my $current_tile;
my $lines;

while (<>) {
    chomp;

    if ($_ =~ /^Tile\s+(\d+)/) {
        $current_tile = $1;
        next;
    }

    if (!$_) {
        $tiles->{$current_tile} = read_into_2d_array($lines);
        $lines = [];
    } else {
        push @$lines, $_;
    }
}

$tiles->{$current_tile} = read_into_2d_array($lines);

my $edges = {};
foreach my $tile (keys %$tiles) {
    my @edges = _get_edges($tiles->{$tile});

    for my $edge (@edges) {
        push @{ $edges->{$edge} }, $tile;
        push @{ $edges->{reverse $edge} }, $tile;
    }
}

my $shared = {};
for my $edge (keys %$edges) {
    my @share = @{$edges->{$edge}};
    for my $t (@share) {
        for (@share) {
            push @{$shared->{$t}}, $_ if $t ne $_;
        }
    }
}

my $total = 1;
for my $tile (keys %$shared) {
    if ((scalar uniq @{$shared->{$tile}}) == 2) {
        $total *= $tile;
    }
}

say $total;

sub _get_edges {
    my $tile = shift;
    my $top    = join '', @{$tile->[0]};
    my $bottom = join '', @{$tile->[-1]};
    my $left   = join '', map { $_->[0]  } @$tile;
    my $right  = join '', map { $_->[-1] } @$tile;

    return ($top, $right, $bottom, $left);
}

