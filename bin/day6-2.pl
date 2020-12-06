#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

my $current;
my $total = 0;
while (<>) {
    chomp;

    if (!$_) {
        $total += keycount($current);
        $current = '';
        next;
    }

    $current .= ($_ . ' ');
}

$total += keycount($current);

print $total . "\n";

sub keycount {
    my $responses = shift;
    my @people = split ' ', $responses;
    my $counts = {};

    foreach my $p (@people) {
        my @resp = split '', $p;
        foreach my $r (@resp) {
            if ($counts->{$r}) {
                $counts->{$r}++;
            } else {
                $counts->{$r} = 1;
            }
        }
    }

    return grep { $counts->{$_} == scalar @people } keys %$counts;
}

