package Advent2020::Boarding;

use strict;
use warnings;

use Exporter;
use Const::Fast;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_seat_id);

const my $MULT => 8;

sub get_seat_id {
    my $pass = shift;

    my $row = substr($pass, 0, 7);
    my $col = substr($pass, 7, 9);

    return _get_row($row) * $MULT + _get_col($col);
    
}

sub _get_row {
    my $pass = shift;
    return _get($pass, 'F', 0, 127);
}

sub _get_col {
    my $pass = shift;
    return _get($pass, 'L', 0, 7);
}

sub _get {
    my ($string, $front_char, $front, $back) = @_; 

    if (length $string == 1) {
        return $string eq $front_char ? $front : $back;
    }   

    my $next = substr($string, 1, (length $string) - 1);
    my $mid = $front + int(($back - $front) / 2);

    if (substr($string, 0, 1) eq $front_char) {
        return _get($next, $front_char, $front, $mid);   
    } else {
        return _get($next, $front_char, $mid + 1, $back);
    }
}

1;
