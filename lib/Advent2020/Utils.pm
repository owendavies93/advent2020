package Advent2020::Utils;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(find_sum_pair read_into_2d_array);

sub find_sum_pair {
    my ($candidate, @nums) = @_; 

    my @sorted = sort { $a <=> $b } @nums;

    my $a = 0;
    my $b = @nums - 1;

    while ($a < $b) {
        my $sum = $sorted[$a] + $sorted[$b];

        if ($sum == $candidate) {
            if (defined wantarray) {
                return ($sorted[$a], $sorted[$b]);
            } else {
                return $candidate;
            }
        }

        if ($sum < $candidate) {
            $a++;
        } else {
            $b--;
        }
    }   

    return 0;
}

sub read_into_2d_array {
    my $data = shift;

    my $ret = [];

    foreach my $line (@$data) {
        push @$ret, [ split //, $line ];
    }

    return $ret;
}

1;
