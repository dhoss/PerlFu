package PerlFu::Job::ProcessXML;

use Moose::Role;
use namespace::autoclean;
use Data::Dumper;

requires qw( document build_hash source );

sub run {
  my $self = shift;
  my $hash = $self->build_hash;
  warn Dumper $hash;
}

1;
