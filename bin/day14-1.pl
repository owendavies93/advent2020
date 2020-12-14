#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

use List::Util qw(sum);

my $mem = {};

while (<>) {
    chomp;

    no warnings 'portable';

    state $mask;
    state $or;
    state $and;

    if ($_ =~ /mask/) {
        $mask = (split ' = ', $_)[1];
        $or  = eval( '0b' . ($mask =~ s/X/0/gr) );
        $and = eval( '0b' . ($mask =~ s/X/1/gr) );
    } else {
        my ($addr, $arg) = $_ =~ /^mem\[(\d+)\]\s+=\s+(\d+)$/;
        $arg |= $or;
        $arg &= $and;
        $mem->{$addr} = $arg;
    }
}

print sum (values %$mem) . "\n";

