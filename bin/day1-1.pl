#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Utils qw(find_sum_pair);

chomp(my @lines = <>);

my @res = find_sum_pair(2020, @lines);

print $res[0] * $res[1] . "\n";
