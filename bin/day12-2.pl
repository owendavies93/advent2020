#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib';

use Advent2020::Ship qw(run_wp_directions);

chomp(my @lines = <>);

print run_wp_directions(\@lines) . "\n";

