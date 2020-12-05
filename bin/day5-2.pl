#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Boarding qw(get_seat_id);
use List::Util qw(reduce);

my $ids = {};
while (<>) {
    chomp;
    
    my $id = get_seat_id($_);
    $ids->{$id} = 1;
}

for my $i (0..(127 * 8 + 7)) {
    print $i . "\n" if 
        !defined $ids->{$i} && 
         defined $ids->{$i + 1} && 
         defined $ids->{$i - 1};
}

