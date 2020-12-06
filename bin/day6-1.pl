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

    $current .= ($_);
}

$total += keycount($current);

print $total . "\n";

sub keycount {
    my %hash;
    @hash{split '', shift} = {};
    return keys %hash;
}

