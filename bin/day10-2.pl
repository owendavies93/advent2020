#!/usr/bin/env perl

use strict;
use warnings;

chomp(my @lines = <>);

my @sort = sort { $a <=> $b } @lines;

my %keys;
$keys{$_}++ for @sort;

my $max = $sort[-1] + 3;

$keys{0} = 1;
$keys{$max} = 1;

print count(0) . "\n";

my $jescache = {};

sub count {
    my $num = shift;

    no warnings 'recursion';
    
    return 1 if $num >= $max;
    return 0 if !$keys{$num};

    return $jescache->{$num} if defined $jescache->{$num};

    my $sum = 0;
    foreach (1..3) {
        $sum += count($num + $_);
    }
    $jescache->{$num} = $sum;
    return $jescache->{$num};
}

