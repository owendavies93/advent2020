package Advent2020::Expenses;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(find_2020_sum);

my $jescache = {};

sub find_2020_sum {
    my $input = shift;

    my $res = [];
    my $i = 0;
    my $target = 2020;

    foreach my $v (reverse @$input) {
        if (_find_sums($input, $i + 1, $target - $v) > 0) {
            push @$res, $v;
            $target -= $v;
        }
        $i++;
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
