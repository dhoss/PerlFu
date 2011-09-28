package PerlFu::Web::Model::Validator;

use Moose;
use namespace::autoclean;
use Data::Manager;
use Data::Verifier;
use Data::Dumper;
use Carp qw( croak );
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

has 'profile' => (
  is       => 'rw',
  isa      => 'HashRef',
  traits   => ['Hash'],
  lazy     => 1,
  required => 1,
  handles  => {
    'get_profile' => 'get',
    'scopes'      => 'keys',
  },
  builder => '_build_profile',
);

sub build_per_context_instance {
  my ( $self, $c ) = @_;
  my %dm_args = ();
  if ( $c->stash->{messages} ) {
    $dm_args{messages} = $c->stash->{messages};
  }

  my $dm = Data::Manager->new(%dm_args);
  foreach my $scope ( $self->scopes ) {
    $c->log->debug("SCOPE $scope");
    $dm->set_verifier(
      $scope => Data::Verifier->new( profile => $self->get_profile($scope) ) );
  }
  return $dm;

}

sub _build_profile {
  {
    create_thread => {
      title => {
        required   => 1,
        type       => 'Str',
        max_length => 255,
        min_length => 1
      },
      tags => {
        required   => 0,
        type       => 'Str',
        max_length => 1024,
        min_length => 1,
      },
      body => {
        required   => 1,
        type       => 'Str',
        min_length => 1,
      },
      author => {
        required => 1,
        type     => 'Int',
      },
      parent => {
        required => 0,
        type     => 'Int',
      },
      path => {
        required   => 0,
        type       => 'Str',
        min_length => 1,
      },
    },
    create_reply => {
      title => {
        required   => 1,
        type       => 'Str',
        max_length => 255,
        min_length => 1
      },
      tags => {
        required   => 0,
        type       => 'Str',
        max_length => 1024,
        min_length => 1,
      },
      body => {
        required   => 1,
        type       => 'Str',
        min_length => 1,
      },
      author => {
        required => 1,
        type     => 'Int',
      },
      parent => {
        required => 1,
        type     => 'Int',
      },
      path => {
        required   => 0,
        type       => 'Str',
        min_length => 1,
      },
    }
  };
}
__PACKAGE__->meta->make_immutable;
1;
