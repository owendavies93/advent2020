package Advent2020::Utils;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(find_sum_pair);

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

1;
