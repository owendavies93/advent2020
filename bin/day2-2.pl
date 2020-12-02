#/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';

use Advent2020::Passwords qw(check_password);

my $path = $ARGV[0];

open my $fh, '<', $path;
chomp(my @lines = <$fh>);
close $fh;

my $count = 0;
foreach my $l (@lines) {
    $count += check_password($l, 1);
}

print $count . "\n";

