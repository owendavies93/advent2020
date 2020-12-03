package Advent2020::Toboggan;

use strict;
use warnings;

use Const::Fast;
use Exporter;

const my $JUMP => 3;
const my $TREE => '#';

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(read_into_2d_array find_trees);

sub read_into_2d_array {
    my $data = shift;

    my $ret = [];

    foreach my $line (@$data) {
        push @$ret, [ split //, $line ];
    }

    return $ret;
}

sub find_trees {
    my $data = shift;

    my $x = scalar @{$data->[0]};
    my $y = scalar @$data;
    my $total = 0;
    my $pos = $JUMP;

    for(my $i = 1; $i <= $y; $i++) {
        my $line = $data->[$i];
        $total += ($line->[$pos % $x] eq $TREE);
        $pos += $JUMP;
    }

    return $total;
}

