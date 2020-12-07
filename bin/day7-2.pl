#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Bags qw(create_num_mappings check_bag_count);

chomp(my @lines = <>);

create_num_mappings(\@lines);

print check_bag_count('shiny gold') . "\n";
