#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Bags qw(create_mappings check_bag);

chomp(my @lines = <>);

create_mappings(\@lines);

print check_bag('shiny gold') . "\n";
