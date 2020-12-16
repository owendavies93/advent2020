#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(sum);

my $valid = {};

while (<>) {
    chomp;

    last if !$_;

    my ($l1, $h1, $l2, $h2) = $_ =~ /(\d+)-(\d+)\sor\s(\d+)-(\d+)/;

    for my $n ($l1..$h1) {
        $valid->{$n} = 1;
    }

    for my $n ($l2..$h2) {
        $valid->{$n} = 1;
    }
}

while (<>) {
    last if /nearby tickets:/;
}

my $count = 0;   

while (<>) {
    chomp;

    my @invalid = grep { !$valid->{$_} } split ',', $_;
    next unless @invalid;

    $count += sum @invalid;
}

print $count . "\n";
