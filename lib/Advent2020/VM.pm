package Advent2020::VM;

use strict;
use warnings;

use Const::Fast;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(run);

const my $COMS => {
    nop => sub {
        my ($arg, $ptr, $acc) = @_;
        return ($ptr + 1, $acc);
    },
    acc => sub {
        my ($arg, $ptr, $acc) = @_;
        my ($op, $num) = _parse_arg($arg);
        
        $ptr++;
        return $op eq '+' ? ($ptr, $acc + $num) : ($ptr, $acc - $num);
    },
    jmp => sub {
        my ($arg, $ptr, $acc) = @_;
        my ($op, $num) = _parse_arg($arg);

        return $op eq '+' ? ($ptr + $num, $acc) : ($ptr - $num, $acc);
    },
};

sub run {
    my @comms = @_;
    
    my $acc = 0;
    my $ptr = 0;
    my $tracker = {};

    while ($ptr < scalar @comms) {
        my ($comm, $arg) = _parse_comm($comms[$ptr]);
        if (defined $tracker->{$ptr}) {
            warn "loop! - acc: " . $acc;
            last;
        }

        $tracker->{$ptr} = 1;
        ($ptr, $acc) = $COMS->{$comm}->($arg, $ptr, $acc);
    }
}

sub _parse_comm {
    my $line = shift;
    return $line =~ /^(\w+)\s+(.*)$/;
}

sub _parse_arg {
    my $arg = shift;
    return $arg =~ /^(\+|\-)(\d+)$/;
}

1;
