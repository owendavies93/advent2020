#!/usr/bin/env perl

use strict;
use warnings;

use Math::Factor::XS qw(factors);

chomp(my ($ts, $ids) = <>);

my @factors = grep { /\d+/ } split ',', $ids;
my %fs;
$fs{$_}++ foreach (@factors);
my $original_ts = $ts;

my $answer;
while (!defined $answer) {
    my @facs = factors($ts);

    foreach (@facs) {
        if ($fs{$_}) {
            $answer = $_;
            last;
        }
    }
    $ts++ unless defined $answer;
}

my $diff = $ts - $original_ts;
print $diff * $answer . "\n";

