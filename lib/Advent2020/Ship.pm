package Advent2020::Ship;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run_directions run_wp_directions);

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

const my $WAY_COMMS => {
    L => sub {
        my ($arg, $x, $y, $dir) = @_;

        my $deg = $arg / 90;

        for my $i (1..$deg) {
            my $tmp = $x;
            $x = -$y;
            $y = $tmp;
        }

        return ($x, $y, $dir);
    },
    R => sub {
        my ($arg, $x, $y, $dir) = @_;

        my $deg = $arg / 90;

        for my $i (1..$deg) {
            my $tmp = $y;
            $y = -$x;
            $x = $tmp;
        }

        return ($x, $y, $dir);
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

sub run_wp_directions {
    my $input = shift;

    my $x = 0;
    my $y = 0;
    my $wx = 10;
    my $wy = 1;
    my $dir = 'E';

    foreach my $i (@$input) {
        my ($comm, $arg) = _parse_comm($i);

        if ($comm eq 'F') {
            $x += $wx * $arg;
            $y += $wy * $arg;
        } elsif ($comm =~ /L|R/) {
            ($wx, $wy, $dir) = $WAY_COMMS->{$comm}->($arg, $wx, $wy, $dir);
        } else {
            ($wx, $wy, $dir) = $COMMS->{$comm}->($arg, $wx, $wy, $dir);
        }
    }

    return abs($x) + abs($y);
}

sub _parse_comm {
    return shift =~ /^(\w)(\d+)$/;
}

1;
