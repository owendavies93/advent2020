#!/usr/bin/env perl

use strict;
use warnings;

use v5.10;

use Const::Fast;

const my $SN  => 7;
const my $MOD => 20201227;
const my $CPK => 17773298;
const my $DPK => 15530095;

my $val = 1;
my $count = 0;
while ($val != $CPK) {
    $count++;
    $val = $SN * $val % $MOD;
}

my $result = $DPK;
for (2..$count) {
    $result = $result * $DPK % $MOD;
}
say $result;

