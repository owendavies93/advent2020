#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Passports 
    qw(tokenise check_required_fields check_valid_values);

my @data;
my $current;
while (<>) {
    chomp;

    if (!$_) {
        push @data, $current;
        $current = '';
        next;
    }

    $current .= ($_ . ' ');
}
push @data, $current;

my $count = 0;
foreach my $line (@data) {
    my $passport = tokenise($line);
    $count += (check_required_fields($passport) && 
               check_valid_values($passport));
}

print $count . "\n";

