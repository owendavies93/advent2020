#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Bags qw(create_mappings check_bag);

chomp(my @lines = <>);

print check_bag(create_mappings(\@lines), 'shiny gold') . "\n";

