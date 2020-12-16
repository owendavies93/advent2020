#!/usr/bin/env perl

use strict;
use warnings;

use Storable qw(dclone);

my $valid = {};
my $rules = {};

while (<>) {
    chomp;

    last if !$_;

    my ($rule_name, $vals) = split /:\s+/, $_;

    my ($l1, $h1, $l2, $h2) = $vals =~ /(\d+)-(\d+)\sor\s(\d+)-(\d+)/;

    for my $n ($l1..$h1) {
        $valid->{$n} = 1;
    }

    for my $n ($l2..$h2) {
        $valid->{$n} = 1;
    }

    $rules->{$rule_name} = [
        { l => $l1, h => $h1 },
        { l => $l2, h => $h2 },
    ];
}

<>;
chomp(my @my_ticket = split ',', <>);
<>;

my $ticket_copy = dclone(\@my_ticket);

my @valid_tickets;
while (<>) {
    chomp;

    my @t = split ',', $_;
    push @valid_tickets, [@t] unless grep { !$valid->{$_} } @t;
}

my @all_tickets = (\@my_ticket, @valid_tickets);
my $result;

for (0..(scalar @my_ticket)) {
    for my $rule_name (keys %$rules) {
        my @candidates;

        my $rule = $rules->{$rule_name};
        my $field_count = scalar @{$all_tickets[0]};
        my $ticket_count = scalar @all_tickets;

        for my $field (0..($field_count - 1)) {           
            my $match_count = 0;
            
            for my $t (@all_tickets) {
                next if !defined $t->[$field];

                if (
                    ($rule->[0]->{l} <= $t->[$field] &&
                     $rule->[0]->{h} >= $t->[$field] ) ||
                    ($rule->[1]->{l} <= $t->[$field] &&
                     $rule->[1]->{h} >= $t->[$field] )
                ) {
                    $match_count++;
                }
            }

            push @candidates, $field if $match_count == $ticket_count;
        }

        # only consider the rule a match if it's the only
        # possible match for this iteration
        if (scalar @candidates == 1) {
            my $field = $candidates[0];

            $result->{$rule_name} = $field;

            delete $rules->{$rule_name};
            for my $t (@all_tickets) {
                delete $t->[$field];
            }
        }
    }
}

my $total = 1;
for my $k (keys %$result) {
    next unless $k =~ /departure/;

    $total *= $ticket_copy->[$result->{$k}]
}

print $total . "\n";

