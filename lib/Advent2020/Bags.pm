package Advent2020::Bags;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK =
    qw(create_mappings create_num_mappings check_bag check_bag_count);

my $jescache = {};

sub create_mappings {
    my $lines = shift;

    my $colour_mappings = {};
    foreach my $l (@$lines) {
        my ($key, $l_mappings) = _tokenise($l);
        foreach my $m (@$l_mappings) {
            push @{$colour_mappings->{$m->{desc}}}, $key;
        }
    }

    return $colour_mappings;
}

sub create_num_mappings {
    my $lines = shift;

    my $colour_mappings = {};
    foreach my $l (@$lines) {
        my ($key, $l_mappings) = _tokenise($l);
        foreach my $m (@$l_mappings) {
            push @{$colour_mappings->{$key}}, $m;
        }
    }

    return $colour_mappings;
}

sub check_bag {
    my ($mappings, $bag) = @_;
    
    my $count = 0;
    foreach my $b (@{$mappings->{$bag}}) {
        if (!defined $jescache->{$b}) {
            $jescache->{$b} = 1;
            $count++;
            $count += check_bag($mappings, $b);
        }
    }

    return $count;
}

sub check_bag_count {
    my ($mappings, $bag) = @_;

    my $count = 0;
    foreach my $b (@{$mappings->{$bag}}) {
        my $total = $b->{num} +
                    $b->{num} * check_bag_count($mappings, $b->{desc});
        $count += $total;
    }

    return $count;
}

sub _tokenise {
    my $line = shift;

    my ($key, $vals) = split /\s*bags\s*contain\s*/, $line;
    
    my @vals = split /,\s*/, $vals;
    my $mappings = [];
    
    foreach my $v (@vals) {
        my ($num, $desc) = $v =~ /(\d+)\s+(.+)\s+bag/;

        last if !defined $num; # no other bags
    
        push @$mappings, {
            num  => $num,
            desc => $desc,
        };
    }

    return ($key, $mappings);
}
