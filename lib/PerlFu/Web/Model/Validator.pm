package PerlFu::Web::Model::Validator;

use Moose;
use namespace::autoclean;
use Data::Manager;
use Data::Verifier;
use Carp qw( croak );
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

has 'ctx' => (
  is => 'rw',
  lazy => 1,
  required => 1,
  default => sub { croak "Oops, no context object set" },
);

has 'messages' => (
  is => 'rw',
  lazy => 1,
  default => ""
);

has 'results' => (
  is => 'rw',
  lazy => 1,
  default => ""
);

sub build_per_context_instance {
  my ( $self, $c ) = @_;
  $self->ctx($c); 
  my $dv = Data::Verifier->new($self->profile);
  my $dm = $self->dm;

  $dm->set_verifier($c->action->name, $dv);
  return $self;
}

sub _build_profile {
  return {}
}

sub validate {
  my ( $self, $params ) = @_;
  my $c = $self->ctx;
  my $dm = $self->dm;
  $dm->verify($c->action->name, $params);
  $self->results($dm->get_results($c->action->name));
  $self->messages($dm->messages_for_scope($c->action->name));
  return $self;
}

__PACKAGE__->meta->make_immutable;
1;
