package PerlFu::Web::Controller::User;

use Moose;
use namespace::autoclean;
use Try::Tiny;
BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPart('user') CaptureArgs(0) {
  my ( $self, $c ) = @_;

}

sub load_user : Chained('base') PathPart('') CaptureArgs(1) {
  my ( $self, $c, $userid ) = @_;
  $c->stash( user => $c->model('Database::User')->find($userid) );
}

sub read : Chained('load_user') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub update : Chained('load_user') PathPart('update') Args(0) {
  my ( $self, $c ) = @_;
  my $user   = $c->stash->{'user'};
  my $params = $c->req->params;
  if ( defined $params ) {
    try {
      my $updated_user = $c->model('Database')->txn_do(
        sub {
          $user->update( $results->valid_values )
        }
      );
      $c->stash( updated => $updated_user );
    } catch {
      $c->stash( errors => $_ );
      $c->detach('/errors');
    };
  }
}

sub create : Chained('base') PathPart('new') Args(0) {
  my ( $self, $c ) = @_;
  my $params = $c->req->params;
  if ( defined $params ) {
    try {
      my $user = $c->model('Database')->txn_do(
        sub { 
          my $u = $c->model('Database::User')->create($params)
            or die "Can't create user: $!";
        }
      );
      $c->stash( user => $user );
    } catch {
      $c->stash( errors => $_ );
      $c->detach('/errors');
    };
  }
}

__PACKAGE__->meta->make_immutable;

1;
