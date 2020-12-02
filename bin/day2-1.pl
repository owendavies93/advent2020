#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Passwords qw(check_password);

my $count = 0;
while(<>) {
    $count += check_password($_);
}

print $count . "\n";

