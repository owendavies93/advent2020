package Advent2020::Toboggan;

use strict;
use warnings;

use Const::Fast;
use Exporter;

const my $TREE => '#';
const my $LIMIT => 10000;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(read_into_2d_array find_trees);

my $jescache = {};

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
        my $key = (join '', @$line) . '-' . $i . '-' . $pos;

        if (defined $jescache->{$key}) {
            $total += $jescache->{$key};
            next;
        } else {
            my $test = $line->[$pos % $x] eq $TREE;
            $total += $test;
            $jescache->{$key} = $test;
        }

        $pos += $jump;

        $jescache = {} if scalar keys %$jescache > $LIMIT;
    }

    return $total;
}

