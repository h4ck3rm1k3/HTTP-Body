#!/usr/bin/perl

use strict;
use warnings;
use lib './lib';

use Data::Dumper;
use HTTP::Body;
use IO::File;
use YAML qw[LoadFile];

my $test = shift(@ARGV) || 1;

my $headers = LoadFile( sprintf( "t/data/multipart/%.3d-headers.yml", $test ) );
my $content = IO::File->new( sprintf( "t/data/multipart/%.3d-content.dat", $test ), O_RDONLY );
my $parser  = HTTP::Body->new( $headers->{'Content-Type'}, $headers->{'Content-Length'} );

warn ref($parser);

binmode $content;

while ( $content->read( my $buffer, 1024 ) ) {
    last if $parser->add($buffer) == 0;
}

warn "length   : $parser->{length}\n";
warn "state    : $parser->{state}\n";

warn Dumper( $parser->param );
warn Dumper( $parser->upload );
