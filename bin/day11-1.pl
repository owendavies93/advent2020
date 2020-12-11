#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Toboggan qw(read_into_2d_array);
use Advent2020::Seats qw(count_occupied run_all_rounds);

chomp(my @lines = <>);

my $arr = read_into_2d_array(\@lines);

$arr = run_all_rounds($arr, 1, 4);

print count_occupied($arr) . "\n";
