package Advent2020::VM;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run parse_comm);

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
    my @comms = @_;
    
    my $acc = 0;
    my $ptr = 0;
    my $tracker = {};

    while ($ptr < (scalar @comms)) {
        my ($comm, $arg) = parse_comm($comms[$ptr]);
        if (defined $tracker->{$ptr}) {
            warn "loop! - acc: " . $acc . "\n";
            return 0;
        }

        $tracker->{$ptr} = 1;
        ($ptr, $acc) = $COMS->{$comm}->($arg, $ptr, $acc);
    }

    return $acc;
}

sub parse_comm {
    split ' ', shift;
}

1;
