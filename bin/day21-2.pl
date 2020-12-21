#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

use List::Util qw(sum);

my $ingredients;
my $allergens;

while (<>) {
    chomp;

    my ($ings, $als) = split /\s+\(/, $_;

    ($als) = $als =~ /^contains\s+(.*)\)$/;
    my @ings = split /\s+/, $ings;
    my @als = split /,\s+/, $als;

    $ingredients->{$_}++ for @ings; 

    foreach my $a (@als) {
        $allergens->{$a}->{count}++;
        $allergens->{$a}->{ing_counts}->{$_}++ for @ings;
    }
}

my $maybe_allergens;

foreach my $a (keys %$allergens) {
    foreach my $i (keys %{$allergens->{$a}->{ing_counts}}) {
        if ($allergens->{$a}->{ing_counts}->{$i} == 
            $allergens->{$a}->{count}) {
            $maybe_allergens->{$i}->{$a} = 1;
        }
    }
}

my $allergen_count = scalar keys %$allergens;
my $res;

for (0..$allergen_count) {
    my @solved = grep { keys %{$maybe_allergens->{$_}} == 1 }
                 keys %$maybe_allergens;

    foreach my $i (@solved) {
        my @als = keys %{$maybe_allergens->{$i}};
        my $al = shift @als;
        $res->{$al} = $i;
        delete $maybe_allergens->{$_}->{$al} for keys %$maybe_allergens;
    }
}

say join ",", map { $res->{$_} } sort keys %$res;

