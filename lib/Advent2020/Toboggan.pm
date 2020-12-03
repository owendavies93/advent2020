package Advent2020::Toboggan;

use strict;
use warnings;

use Const::Fast;
use Exporter;

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
    my ($data, $jump, $skip) = @_;

    my $x = scalar @{$data->[0]};
    my $y = scalar @$data;
    my $total = 0;
    my $pos = $jump;

    for (my $i = $skip; $i < $y; $i += $skip) {
        my $line = $data->[$i];
        $total += ($line->[$pos % $x] eq $TREE);
        $pos += $jump;
    }

    return $total;
}

