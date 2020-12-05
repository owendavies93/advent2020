#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Boarding qw(get_seat_id);
use List::Util qw(reduce);

my $max = 0;
while (<>) {
    chomp;
    
    my $id = get_seat_id($_);
    if ($id > $max) {
        $max = $id;
    }
}

print $max . "\n";

