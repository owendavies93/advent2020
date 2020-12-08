#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::VM qw(run);

chomp(my @lines = <>);

run(@lines);

