#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Toboggan qw(read_into_2d_array find_trees);

chomp(my @lines = <>);

my $arr = read_into_2d_array(\@lines);
print find_trees($arr, 1, 1) *
      find_trees($arr, 3, 1) *
      find_trees($arr, 5, 1) *
      find_trees($arr, 7, 1) *
      find_trees($arr, 1, 2) . "\n";

