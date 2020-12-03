#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Toboggan qw(read_into_2d_array find_trees);

chomp(my @lines = <>);

my $arr = read_into_2d_array(\@lines);
print find_trees($arr);

