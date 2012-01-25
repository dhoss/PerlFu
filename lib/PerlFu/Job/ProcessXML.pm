package PerlFu::Job::ProcessXML;

use Moose::Role;
use Moose::Util;
use namespace::autoclean;
use Data::Dumper;

# interface for processing xml
requires qw( document build_hash source params );

sub run {
  my $self   = shift;
  my $params = $self->params;
  my $type   = $params->{'type'};
  apply_all_roles($self, "XML::".$type);
}

1;
