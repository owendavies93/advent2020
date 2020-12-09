package Advent2020::VM;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run run_with_loops step parse_comm);

const my $COMS => {
    nop => sub {
        my ($arg, $ptr, $acc) = @_;
        return (++$ptr, $acc);
    },
    acc => sub {
        my ($arg, $ptr, $acc) = @_;
        return (++$ptr, $acc + $arg);
    },
    jmp => sub {
        my ($arg, $ptr, $acc) = @_;
        return ($ptr + $arg, $acc);
    },
};

sub run {
    return _run(0, 0, 1, @_);
}

sub run_with_loops {
    return _run(0, 0, 0, @_);
}

sub step {
    my ($acc, $ptr, $comm) = @_;

    my ($c, $a) = parse_comm($comm);
    return $COMS->{$c}->($a, $ptr, $acc);
}

sub parse_comm {
    split ' ', shift;
}

sub _run {
    my ($acc, $ptr, $tracking, @comms) = @_;

    my $tracker = {};

    while ($ptr < (scalar @comms)) {
        if ($tracking) {
            if (defined $tracker->{$ptr}) {
                warn "loop! - acc: " . $acc . "\n";
                return 0;
            }

            $tracker->{$ptr} = 1;
        }

        ($ptr, $acc) = step($acc, $ptr, $comms[$ptr]);
    }

    return $acc;
}

1;
