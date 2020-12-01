package Advent2020::Expenses;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(find_2020_sum);

const my $TARGET => 2020;

my $jescache = {};

sub find_2020_sum {
    my ($input, $size) = @_;

    my $res = [];
    my $indices = [];
    my $i = 0;
    my $target = $TARGET;
    my $orig_size = $size;

    my $a = 1;

    while ($size > 0) {
        foreach my $v (@$input) {
            if (_find_sums($input, $i + 1, $target - $v) > 0) {
                $size--;
                push @$res, $v;
                push @$indices, $i;
                $target -= $v;
            }
            $i++;
        }

        if ($size != 0) {
            splice(@$input, $indices->[0], 1);
            $i = 0;
            $res = [];
            $indices = [];
            $size = $orig_size;
            $target = $TARGET;
        }
    }

    return $res;
}

sub _find_sums {
    my ($input, $i, $s) = @_;

    if ($i >= scalar @$input || $s < 0) {
        return $s == 0;
    }

    my $key = $i . '-' . $s;
    return $jescache->{$key} if defined $jescache->{$key};

    no warnings 'recursion';

    my $count = _find_sums($input, $i + 1, $s);
    $count += _find_sums($input, $i + 1, $s - $input->[$i]);

    $jescache->{$key} = $count;
    return $count;
}

1;
