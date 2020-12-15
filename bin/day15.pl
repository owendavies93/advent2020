#!/usr/bin/env perl

use strict;
use warnings;

chomp(my $line = <>);

my @input = split ',', $line;
my $start = scalar @input;

my $seen = {};
$seen->{$input[$_]} = ($_ + 1) for (0..($start - 1));

my $last_seen = $input[$start - 1];

for (my $i = $start + 1; $i <= 30_000_000; $i++) {
    my $l_pos = $seen->{$last_seen};
    my $new = $l_pos ? $i - 1 - $l_pos : 0;

    print "turn $i - last number spoken: $last_seen, when: $l_pos, new number: $new\n";

    $seen->{$last_seen} = $i - 1;
    $last_seen = $new;
}

print $last_seen . "\n";

