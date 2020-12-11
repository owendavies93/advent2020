package Advent2020::Seats;

use strict;
use warnings;

use Const::Fast;
use Data::Compare;
use Exporter;
use Storable qw(dclone);

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(count_occupied print_seats run_all_rounds);

sub count_occupied {
    my $input = shift;

    my $total = 0;
    for (my $j = 0; $j < @$input; $j++) {
        $total += scalar grep { _is_occupied($_) } @{$input->[$j]};
    }

    return $total;
}

sub print_seats {
    my $input = shift;

    foreach my $row (@$input) {
        print join ('', @$row) . "\n";
    }
}

sub run_all_rounds {
    my $input = shift;

    my $old;

    while (!Compare($input, $old)) {
        $old = dclone($input);
        $input = step_round($input);
    }

    return $input;
}

sub step_round {
    my $input = shift;

    my $ret = dclone($input);

    for (my $i = 0; $i < @{$input->[0]}; $i++) {
        for (my $j = 0; $j < @$input; $j++) {
            my $seat = $input->[$j]->[$i];

            next if $seat eq '.';

            if (_is_empty($seat) && 
                _get_seen_seats($input, $i, $j) == 0) {
                $ret->[$j]->[$i] = '#';
            } elsif (_is_occupied($seat) && _get_seen_seats($input, $i, $j) >= 5) {
                $ret->[$j]->[$i] = 'L';
            }
        }
    }

    return $ret;
}

sub _get_adjacent {
    my ($input, $x, $y) = @_;

    my @xs = (-1, 0, 1, 1, 1, 0,-1,-1);
    my @ys = ( 1, 1, 1, 0,-1,-1,-1, 0);

    my $res = [];
    for (my $i = 0; $i < @xs; $i++) {
        my $x_ = $x + $xs[$i];
        next if $x_ < 0 || $x_ >= @{$input->[0]};

        my $y_ = $y + $ys[$i];
        next if $y_ < 0 || $y_ >= @$input;

        push $res, $input->[$y_]->[$x_];
    }

    return $res;
}

sub _get_seen_seats {
    my ($input, $x, $y) = @_;

    my @xs = (-1, 0, 1, 1, 1, 0,-1,-1);
    my @ys = ( 1, 1, 1, 0,-1,-1,-1, 0);

    my $count = 0;
    for (my $i = 0; $i < @xs; $i++) {
        my $hit = 0;
        my $mult = 1;

        while (!$hit) {
            my $x_ = $x + $xs[$i] * $mult;
            last if $x_ < 0 || $x_ >= @{$input->[0]};

            my $y_ = $y + $ys[$i] * $mult;
            last if $y_ < 0 || $y_ >= @$input;

            $count++ if _is_occupied($input->[$y_]->[$x_]);

            if (_is_empty($input->[$y_]->[$x_]) || _is_occupied($input->[$y_]->[$x_])) {
                $hit = 1;
            }

            $mult++;
        }
    }

    return $count;
}

sub _is_empty {
    return shift eq 'L';
}

sub _is_occupied {
    return shift eq '#';
}

1;
