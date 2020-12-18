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

    my @parts = split /\s+/, $expr;
    my $total = $parts[0];
    my $op    = $parts[1];

    for (my $i = 2; $i < @parts; $i++) {
        my $p = $parts[$i];

        if ($p eq '+' || $p eq '*') {
            $op = $p;
        } else {
            if ($op eq "+") {
                $total += $p;
            } else {
                $total *= $p;
            }
        }
    }

    return $total;
}
