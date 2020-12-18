#!/usr/bin/env perl

use strict;
use warnings;

my $total = 0;

while (<>) {
    chomp;

    my $line = $_;
    while (my ($expr) = $line =~ /(\([^\(\)]+\))/) {
        my $res = evaluate_expression($expr =~ s/\(|\)//gr);
        
        $line =~ s/\Q$expr\E/$res/;
    }

    $total += evaluate_expression($line);
}

print $total . "\n";

sub evaluate_expression {
    my $expr = shift;

    while (my ($add) = $expr =~ /(\d+\s+\+\s+\d+)/) {
        my ($x, $y) = split /\s+\+\s+/, $add;
        my $res = $x + $y;

        $expr =~ s/\Q$add\E/$res/;
    }

    while (my ($mult) = $expr =~ /(\d+\s+\*\s+\d+)/) {
        my ($x, $y) = split /\s+\*\s+/, $mult;
        my $res = $x * $y;

        $expr =~ s/\Q$mult\E/$res/;
    }

    return $expr;
}
