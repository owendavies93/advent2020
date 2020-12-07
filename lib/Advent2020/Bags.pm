package Advent2020::Bags;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(create_mappings check_bag);

my $colour_mappings = {};
my $jescache = {};

sub create_mappings {
    my $lines = shift;

    foreach my $l (@$lines) {
        my ($key, $l_mappings) = _tokenise($l);
        foreach my $m (@$l_mappings) {
            push @{$colour_mappings->{$m->{desc}}}, $key;
        }
    }
}

sub check_bag {
    my $bag = shift;
    
    my $count = 0;
    foreach my $b (@{$colour_mappings->{$bag}}) {
        if (!defined $jescache->{$b}) {
            $jescache->{$b} = 1;
            $count++;
            $count += check_bag($b);
        }
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
