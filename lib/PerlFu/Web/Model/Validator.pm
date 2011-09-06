package PerlFu::Web::Model::Validator;

use Moose;
use namespace::autoclean;
use Data::Manager;
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

sub build_per_context_instance {
  my ( $self, $c ) = @_;
}

__PACKAGE__->meta->make_immutable;
1;
