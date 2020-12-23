#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

use List::AllUtils qw(any firstidx max);

my $input = "186524973";

my @cups = split '', $input;
my $top = max @cups;
my $last =  pop @cups;
unshift @cups, $last;

for (1..100) {
    my $to_rotate = shift @cups;
    push @cups, $to_rotate;
    
    my @pick_up = @cups[1..3];
    
    splice @cups, 1, 3;
    
    my $new = $cups[0] - 1 < 1 ? $top : $cups[0] - 1;
    my $new_idx = 0;

    while (!grep { $_ eq $new } @cups) {
        $new = $new == 1 ? $top : $new - 1;
    }
    $new_idx = firstidx { $_ == $new } @cups;

    splice @cups, $new_idx + 1, 0, @pick_up;
}

my $one_idx = firstidx { $_ == 1 } @cups;

my @front = @cups[0..($one_idx - 1)];
my @back = @cups[($one_idx + 1)..($top - 1)];

print @back;
print @front;
print "\n";
