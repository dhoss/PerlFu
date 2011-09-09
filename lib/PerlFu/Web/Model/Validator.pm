package PerlFu::Web::Model::Validator;

use Moose;
use namespace::autoclean;
use Data::Manager;
use Data::Verifier;
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

has 'profile' => (
  is => 'rw',
  isa => 'HashRef',
  required => 1,
  builder => '_build_profile',
  lazy => 1,
);

has 'dm' => (
  is => 'ro',
  lazy => 1,
  required => 1,
  default => sub { Data::Manager->new },
);

sub build_per_context_instance {
  my ( $self, $c ) = @_;
 
  my $dv = Data::Verifier->new($self->profile);
  my $dm = $self->dm;

  $dm->set_verifier($c->action->name, $dv);

}

sub _build_profile {
  return {}
}

__PACKAGE__->meta->make_immutable;
1;
