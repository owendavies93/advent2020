#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::VM qw(run parse_comm);

chomp(my @lines = <>);

foreach my $l (@lines) {
    my ($com, $arg) = parse_comm($l);
    my $tmp = $l;
    if ($com eq 'nop') {
        $l =~ s/nop/jmp/;
    } elsif ($com eq 'jmp') {
        $l =~ s/jmp/nop/;
    }

    my $acc = run(@lines);
    if ($acc) {
        print $acc . "\n";
        last;
    } else {
        $l = $tmp;
    }
}

