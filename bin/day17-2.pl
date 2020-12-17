#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

my $state;

while (<>) {
    chomp;

    state $y = 0;

    my @line = split '', $_;
    for (my $x = 0; $x < @line; $x++) {
        $state = _store_state($state, $x, $y, 0, 0) if $line[$x] eq '#';
    }

    $y++;
}

my $pos_to_check;

for my $x (-1..1) {
    for my $y (-1..1) {
        for my $z (-1..1) {
            for my $w (-1..1) {
                next if $x == 0 && $y == 0 && $z == 0 && $w == 0;
                push @$pos_to_check, [$x, $y, $z, $w];
            }
        }
    }
}

for (1..6) {
    my $expanded_state = {};
    for my $pos (keys %$state) {
        my ($x, $y, $z, $w) = _get_coords_from_pos($pos);
        for my $to_check (@$pos_to_check) {
            my $x_ = $x + $to_check->[0];
            my $y_ = $y + $to_check->[1];
            my $z_ = $z + $to_check->[2];
            my $w_ = $w + $to_check->[3];

            $expanded_state = _store_state($expanded_state, $x_, $y_, $z_, $w_);
        }
    }

    my $state_with_expansion = { %$state, %$expanded_state };

    my $next_state = {};
    for my $pos (keys %$state_with_expansion) {
        my ($x, $y, $z, $w) = _get_coords_from_pos($pos);
        
        if ($state_with_expansion->{$pos} == 3 ||
            (defined $state->{$pos} && $state_with_expansion->{$pos} == 2)) {
            $next_state = _store_state($next_state, $x, $y, $z, $w);
        }
    }

    $state = $next_state;
}

print scalar keys %$state;
print "\n";

sub _store_state {
    my ($state, $x, $y, $z, $w) = @_;

    my $pos = "$x~$y~$z~$w";
    
    if ($state->{$pos}) {
        $state->{$pos}++;
    } else {
        $state->{$pos} = 1;
    }

    return $state;
}

sub _get_coords_from_pos {
    my $pos = shift;
    return split '~', $pos;
}

