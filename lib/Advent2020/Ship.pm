package Advent2020::Ship;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run_directions);

const my @DIRS => qw(N E S W);
const my $DIR_INDEX => {
    N => 0, E => 1, S => 2, W => 3
};

const my $COMMS => {
    N => sub {
        my ($arg, $x, $y, $dir) = @_;
        return ($x, $y + $arg, $dir);
    },
    S => sub {
        my ($arg, $x, $y, $dir) = @_;
        return ($x, $y - $arg, $dir);
    },
    E => sub {
        my ($arg, $x, $y, $dir) = @_;
        return ($x + $arg, $y, $dir);
    },
    W => sub {
        my ($arg, $x, $y, $dir) = @_;
        return ($x - $arg, $y, $dir);
    },
    L => sub {
        my ($arg, $x, $y, $dir) = @_;

        my $i = $DIR_INDEX->{$dir};
        my $deg = $arg / 90;
        my $new = $DIRS[($i - $deg) % @DIRS];

        return ($x, $y, $new);
    },
    R => sub {
        my ($arg, $x, $y, $dir) = @_;

        my $i = $DIR_INDEX->{$dir};
        my $deg = $arg / 90;
        my $new = $DIRS[($i + $deg) % @DIRS];

        return ($x, $y, $new);
    }
};

sub run_directions {
    my $input = shift;

    my $x = 0;
    my $y = 0;
    my $dir = 'E';

    foreach my $i (@$input) {
        my ($comm, $arg) = _parse_comm($i);
        
        if ($comm eq 'F') {
            ($x, $y, $dir) = $COMMS->{$dir}->($arg, $x, $y, $dir);
        } else {
            ($x, $y, $dir) = $COMMS->{$comm}->($arg, $x, $y, $dir);
        }
    }

    return abs($x) + abs($y);
}

sub _parse_comm {
    return shift =~ /^(\w)(\d+)$/;
}

1;
