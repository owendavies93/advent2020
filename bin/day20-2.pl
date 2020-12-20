#!/usr/bin/env/perl

use strict;
use warnings;

use v5.10;

use lib '../lib';

use List::Util qw(uniq min max);
use Advent2020::Utils qw(read_into_2d_array);

my $tiles = {};
my $current_tile;
my $lines;

while (<>) {
    chomp;

    if ($_ =~ /^Tile\s+(\d+)/) {
        $current_tile = $1;
        next;
    }

    if (!$_) {
        $tiles->{$current_tile} = read_into_2d_array($lines);
        $lines = [];
    } else {
        push @$lines, $_;
    }
}

$tiles->{$current_tile} = read_into_2d_array($lines);

my $edges = {};
foreach my $tile (keys %$tiles) {
    my @edges = _get_edges($tiles->{$tile});

    for my $edge (@edges) {
        push @{ $edges->{$edge} }, $tile;
        push @{ $edges->{reverse $edge} }, $tile;
    }
}

my $shared = {};
for my $edge (keys %$edges) {
    my @share = @{$edges->{$edge}};
    for my $t (@share) {
        for (@share) {
            push @{$shared->{$t}}, $_ if $t ne $_;
        }
    }
}

my %shared_edge_count = map {
    $_ => scalar uniq @{$shared->{$_}}
} keys %$shared;

my $num_tiles = scalar keys %$tiles;
my $edge_length = 9;
my $tiles_dimension = sqrt $num_tiles;
my @rotations = (0, 90, 180, 270);
my @possible_answers;
my $excluded_answers = {};

OUTER: while(1) {
    my $answer = '';
    my $jes_cache = {};
    my $current_tiles = {};

    for (my $y = 1; $y <= $tiles_dimension; $y++) {
        TILE: for (my $x = 1; $x <= $tiles_dimension; $x++) {
            my $is_edge = ($x == 1 || $y == 1 || 
                           $x == $tiles_dimension || $y == $tiles_dimension);
            my $is_corner = ($x == 1 && $y == 1) || 
                            ($x == 1 && $y == $tiles_dimension) ||
                            ($x == $tiles_dimension && $y == 1) ||
                            ($x == $tiles_dimension && $y == $tiles_dimension);
            my $allowed_shared = 4 - $is_edge - $is_corner;

            my @possible_tiles = grep { $shared_edge_count{$_} == $allowed_shared } 
                                 keys %shared_edge_count;

            foreach my $poss (@possible_tiles) {
                # skip if it's in the solution
                next if $jes_cache->{$poss};
                
                for my $r (@rotations) {
                    for my $f (0,1) {
                        my $key = "$x-$y-$poss-$r-$f";

                        # skip if we've already tried this configuration in a broken solution
                        # xxx: potentially dubious
                        if (grep { $_ =~ /$key/ } keys %$excluded_answers) {
                            next;
                        }

                        if (_if_the_shoe_fits($poss, $r, $f, $x, $y, $current_tiles)) {
                            $jes_cache->{$poss} = 1;
                            $answer .= $key;

                            $current_tiles->{$x}->{$y} = {
                                tile_id    => $poss,
                                rotation   => $r,
                                is_flipped => $f,
                            };

                            next TILE;
                        }
                    }
                }           
            }

            $excluded_answers->{$answer} = 1;
            next OUTER;
        }
    }
    
    $excluded_answers->{$answer} = 1;
    push @possible_answers, $current_tiles;
    last if scalar @possible_answers == scalar @rotations * 2;
}

my $min = 1000000;
foreach my $candidate (@possible_answers) {
    my $image = _build_image($candidate);
    my $total = _count_excluding_monster_hashes($image);

    $min = $total if $total < $min;
}

say $min;

sub _monster_map {
    my $monster =<<END;
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
END
    
    my @xs;
    my @ys;

    my @lines = split /\n/, $monster;
    my $arr = read_into_2d_array(\@lines);

    for (my $y = 0; $y < scalar @$arr; $y++) {
        for (my $x = 0; $x < scalar @{$arr->[0]}; $x++) {
            if ($arr->[$y]->[$x] eq '#') {
                push @xs, $x;
                push @ys, $y;
            }
        }
    }

    return (\@xs, \@ys);
}

sub _count_excluding_monster_hashes {
    my $image = shift;

    my ($xs, $ys)      = _monster_map();
    my $map_length     = scalar @$xs;
    my $monster_width  = max(@$xs);
    my $monster_height = max(@$ys);
    
    my $image_height = scalar @$image;
    my $image_width  = scalar @{$image->[0]};

    my $all_monsters = {};

    for (my $y = 0; $y < ($image_height - $monster_height); $y++) {
        OUTER: for (my $x = 0; $x < ($image_width - $monster_width); $x++) {
            my $monster = {};
            for (my $p = 0; $p < $map_length; $p++) {
                my $px = $x + $xs->[$p];
                my $py = $y + $ys->[$p];
                
                next OUTER if $image->[$py]->[$px] ne '#';
            }
            
            for (my $p = 0; $p < $map_length; $p++) {
                my $px = $x + $xs->[$p];
                my $py = $y + $ys->[$p];

                $all_monsters->{$px}->{$py} = 1;
            }
        }
    }

    my $total = 0;
    
    for (my $y = 0; $y < $image_height; $y++) {
        for (my $x = 0; $x < $image_width; $x++) {
            if ($image->[$y]->[$x] eq '#' && !defined $all_monsters->{$x}->{$y}) {
                $total++; 
            }
        }
    }

    return $total;
}

sub _build_image {
    my $images = shift;

    my $result;
    for (my $y = 1; $y <= $tiles_dimension; $y++) {
        for (my $x = 1; $x <= $tiles_dimension; $x++) { 
            my $tile = $images->{$x}->{$y};
        
            for my $a (0..($edge_length - 2)) {
                for my $b (0..($edge_length - 2)) {

                    my $res_x = ($edge_length - 1) * ($x - 1) + $a;
                    my $res_y = ($edge_length - 1) * ($y - 1) + $b;
                    
                    $result->[$res_y]->[$res_x] = 
                        _get_point_from_tile_in_rotation_and_flip(
                            $tile->{tile_id},
                            $tile->{rotation},
                            $tile->{is_flipped},
                            $a + 1,
                            $b + 1,
                        );
                }
            }
        }
    }

    return $result;
}

sub _if_the_shoe_fits {
    my ($tile_id, $rotation, $is_flipped, $x, $y, $current_tiles) = @_;
    
    # Remember that x and y here are within a puzzle, not a tile
    
    return 1 if $x == 1 && $y == 1;
            
    if ($x > 1) {
        my $left_tile = $current_tiles->{$x - 1}->{$y};
        for my $pixel (0..$edge_length) {
            if (
                _get_point_from_tile_in_rotation_and_flip(
                    $left_tile->{tile_id},
                    $left_tile->{rotation},
                    $left_tile->{is_flipped},
                    $edge_length,
                    $pixel) ne
                _get_point_from_tile_in_rotation_and_flip(
                    $tile_id,
                    $rotation,
                    $is_flipped,
                    0,
                    $pixel,
                )
            ) {
                return 0;
            }
        } 
    }

    if ($y > 1) {
        my $top_tile = $current_tiles->{$x}->{$y - 1};
        for my $pixel (0..$edge_length) {
            if (
                _get_point_from_tile_in_rotation_and_flip(
                    $top_tile->{tile_id},
                    $top_tile->{rotation},
                    $top_tile->{is_flipped},
                    $pixel,
                    $edge_length) ne
                _get_point_from_tile_in_rotation_and_flip(
                    $tile_id,
                    $rotation,
                    $is_flipped,
                    $pixel,
                    0,
                )
            ) {
                return 0;
            }
        }
    }

    return 1;
}

sub _get_point_from_tile_in_rotation_and_flip {
    my ($tile_id, $rotation, $is_flipped, $x, $y) = @_;

    # Remember that x and y here are within a tile, not a puzzle
    
    my $deg = $rotation / 90;

    if ($is_flipped) {
        $y = $edge_length - $y;
    }
    
    for (1..$deg) {
        my $tmp = $x;
        $x = $edge_length - $y;
        $y = $tmp;
    }

    return $tiles->{$tile_id}->[$y]->[$x];
}

sub _get_edges {
    my $tile = shift;
    my $top    = join '', @{$tile->[0]};
    my $bottom = join '', @{$tile->[-1]};
    my $left   = join '', map { $_->[0]  } @$tile;
    my $right  = join '', map { $_->[-1] } @$tile;

    return ($top, $right, $bottom, $left);
}

