package PerlFu::Web::Controller::User;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPart('user') CaptureArgs(0) {
  my ( $self, $c ) = @_;

}

sub load_user : Chained('base') PathPart('') CaptureArgs(1) {
  my ( $self, $c, $userid ) = @_;
  $c->stash( 
    user => $c->model('Database::User')->find($userid) 
  );
}

sub read : Chained('load_user') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub update : Chained('load_user') PathPart('update') Args(0) {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $params = $c->req->params;
  my $results = $c->model("Validate::User")->validate($params);
  my $updated_user;
  if ( $results->success ) { 
    
    $updated_user = $c->model('Database')->txn_do(sub {
      $user->update( $results->valid_values ) );
    });
    $c->stash( updated => $updated_user );
  
  } else {
    $c->stash( errors => $results->errors );
    $c->detach('/errors');
  }
}


__PACKAGE__->meta->make_immutable;

1;
