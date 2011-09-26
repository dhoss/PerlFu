package PerlFu::Web::Model::Validator;

use Moose;
use namespace::autoclean;
use Data::Manager;
use Data::Verifier;
use Data::Dumper;
use Carp qw( croak );
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

has 'profiles' => (
  is       => 'rw',
  isa      => 'HashRef',
  traits   => ['Hash'],
  builder  => '_build_profiles',
  lazy     => 1,
  handles  => {
    'get_profile' => 'get',
    'scopes'      => 'keys',
  },
);

sub build_per_context_instance {
  my ( $self, $c ) = @_;
  my %dm_args = ();
  if ( $c->stash->{messages} ) {
    $dm_args{messages} = $c->stash->{messages};
  }
  $c->log->debug("args: " . Dumper \%dm_args);

  my $dm = Data::Manager->new(%dm_args);
  foreach my $scope ( $self->scopes ) {
    $c->log->debug("SCOPE KEY" . $scope);
    $c->log->debug("SCOPE " . Dumper $self->get_profile($scope));
    $dm->set_verifier(
      $scope => Data::Verifier->new( profile => $self->get_profile($scope) ) );
  }
  return $dm;

}

sub _build_profiles {
  return {};
}

__PACKAGE__->meta->make_immutable;
1;
