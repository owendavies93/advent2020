package Advent2020::Passwords;

use strict;
use warnings;

use Exporter;
use List::Util qw(all);

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(check_password);

my $jescache = {};

sub check_password {
    my $line = shift;

    my $info = _tokenise($line);

    return all { _check_constraint($_, $info->{pass}) } 
           @{$info->{constraints}};
}

sub _check_constraint {
    my ($constraint, $password) = @_;

    my $res = {};
    foreach my $char (split '', $password) {
        if ($res->{$char}) {
            $res->{$char}++;
        } else {
            $res->{$char} = 1;
        }
    }

    if (defined $res->{$constraint->{letter}}) {
        return $res->{$constraint->{letter}} >= $constraint->{lower} &&
               $res->{$constraint->{letter}} <= $constraint->{upper};
    } else {
        return 0;
    }
}

sub _tokenise {
    my $line = shift;

    return $jescache->{$line} if defined $jescache->{$line};

    my $ret = {};
    my ($constraints, $password) = split /\s*:\s*/, $line;

    $ret->{pass} = $password;
    $ret->{constraints} = [];
    
    my @constraints = split /\s*,\s*/, $constraints;
    foreach my $c (@constraints) {
        my ($bounds, $letter) = split /\s+/, $c;
        my ($lower, $upper) = split /-/, $bounds;

        push @{$ret->{constraints}}, {
            lower  => $lower,
            upper  => $upper,
            letter => $letter,
        };
    }

    $jescache->{$line} = $ret;
    return $ret;
}
