#!/usr/bin/env perl

use strict;
use warnings;

my $rules = {};
while(<>) {
    chomp;

    last if !$_;

    my ($num, $rule) = split ': ', $_;
    $rules->{$num} = $rule;
}

my @messages;
while(<>) {
    chomp;

    push @messages, $_;
}

my $re = build_regex(0);
print scalar grep { $_ =~ /^$re$/ } @messages;
print "\n";

sub build_regex {
    my $num = shift;

    my $rule = $rules->{$num};

    if (my ($ident) = $rule =~ /"(\w)"/) {
        return $ident;
    } 

    my @ors = split ' ', $rule;
    my $or_regex = '';
    my $bracket = 0;
    for my $o (@ors) {
        if ($o =~ /^\d+/) {
            $or_regex .= build_regex($o);
        }
        else {
            $or_regex .= $o;
            $bracket = 1;
        }
    }

    $or_regex = "($or_regex)" if $bracket;

    return $or_regex;
}

