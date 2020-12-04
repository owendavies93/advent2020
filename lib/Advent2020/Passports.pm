package Advent2020::Passports;

use strict;
use warnings;

use Const::Fast;
use Exporter;
use List::Util qw(all);

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(tokenise check_required_fields check_valid_values);

const my @REQUIRED_FIELDS => qw(byr iyr eyr hgt hcl ecl pid);
const my @OPTIONAL_FIELDS => qw(cid);

const my $VALIDATORS => {
    byr => sub {
        my $byr = shift;
        return $byr =~ /^\d{4}$/ && $byr >= 1920 && $byr <= 2002;
    },
    iyr => sub {
        my $iyr = shift;
        return $iyr =~ /^\d{4}$/ && $iyr >= 2010 && $iyr <= 2020;
    },
    eyr => sub {
        my $eyr = shift;
        return $eyr =~ /^\d{4}$/ && $eyr >= 2020 && $eyr <= 2030;
    },
    hgt => sub {
        my $hgt = shift;
        my ($num, $unit) = $hgt =~ /(\d+)(\w+)/;
       
        if (!defined $unit || !defined $num || 
            ($unit ne 'cm' && $unit ne 'in')) {
            return 0;
        }

        if ($unit eq 'cm') {
            return $num >= 150 && $num <= 193;
        } else {
            return $num >= 59 && $num <= 76;
        }
    },
    hcl => sub { shift =~ /^#[0-9a-f]{6}$/ },
    ecl => sub { shift =~ /^amb|blu|brn|gry|grn|hzl|oth$/ },
    pid => sub { shift =~ /^\d{9}$/ },
    cid => sub { 1 },
};

sub tokenise {
    my $line = shift;

    my @fields = split /\s+/, $line;
    my $ret = {};
    
    foreach my $f (@fields) {
        my ($k, $v) = split ':', $f;
        $ret->{$k} = $v;
    }

    return $ret;
}

sub check_required_fields {
    my $data = shift;

    return all { defined $data->{$_} } @REQUIRED_FIELDS;
}

sub check_valid_values {
    my $data = shift;

    return all { $VALIDATORS->{$_}->($data->{$_}) } keys %$data;
}

1;
