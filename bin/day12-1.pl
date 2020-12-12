#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib';

use Advent2020::Ship qw(run_directions);

chomp(my @lines = <>);

print run_directions(\@lines) . "\n";

