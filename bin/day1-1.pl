#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Expenses qw(find_2020_sum);
use Data::Dumper;

chomp(my @lines = <>);

my $res = find_2020_sum(\@lines, 2);

print $res->[0] * $res->[1];
