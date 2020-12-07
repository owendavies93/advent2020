#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Bags qw(create_num_mappings check_bag_count);

chomp(my @lines = <>);

print check_bag_count(create_num_mappings(\@lines), 'shiny gold') . "\n";

