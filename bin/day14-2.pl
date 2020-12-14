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
    state @x_pos;

    if ($_ =~ /mask/) {
        $mask = (split ' = ', $_)[1];
        my @mask = reverse split '', $mask;
        $or = eval( '0b' . ($mask =~ s/X/0/gr) );

        @x_pos = ();
        for (my $i = 0; $i < @mask; $i++) {
           push @x_pos, $i if $mask[$i] eq 'X';
        }
    } else {
        my ($addr, $arg) = $_ =~ /^mem\[(\d+)\]\s+=\s+(\d+)$/;
        write_all_addrs($addr | $or, $arg, @x_pos);
    }
}

sub write_all_addrs {
    my ($addr, $arg, @x_pos) = @_;

    if (!@x_pos) {
        $mem->{$addr} = $arg;
    } else {
        my $changed_bit = 1 << (shift @x_pos);
        write_all_addrs($addr & ~$changed_bit, $arg, @x_pos);
        write_all_addrs($addr |  $changed_bit, $arg, @x_pos);
    }
}

print sum (values %$mem) . "\n";

