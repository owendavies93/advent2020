#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Expenses qw(find_2020_sum);
use Data::Dumper;

my $path = $ARGV[0];

open my $fh, '<', $path;
chomp(my @lines = <$fh>);
close $fh;

my $res = find_2020_sum(\@lines, 3);

print $res->[0] * $res->[1] * $res->[2];
