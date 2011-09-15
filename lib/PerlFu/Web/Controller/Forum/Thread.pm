package PerlFu::Web::Controller::Forum::Thread;
use Moose;
use namespace::autoclean;
use DBIx::Class::QueryLog;
use DBIx::Class::QueryLog::Analyzer;
use Data::Dumper;
use Try::Tiny;
use Carp::Always;
BEGIN { extends 'PerlFu::Web::Controller::Forum'; }

=head1 NAME

PerlFu::Web::Controller::Forum::Thread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub load_thread : Chained('base') PathPart('thread') CaptureArgs(1) {
  my ( $self, $c, $threadid ) = @_;
  my $schema = $c->model('Database')->schema;
  my $thread = $c->model('Database::Post')->find($threadid);
  $c->detach('thread_not_found') unless defined $thread;
  $c->stash( thread => $thread );
}

sub base : Chained('.') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

=head2 index

=cut

sub index : Chained('base') PathPart('') : Args(0) {
  my ( $self, $c ) = @_;

  my $forum = $c->stash->{'forum'};
  my @threads = $forum->threads->parent_threads;
  $c->stash( threads => \@threads );

}

sub read : Chained('load_thread') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub thread_not_found : Private {
  my ( $self, $c ) = @_;
  $c->error("No such thread");
}

sub create : Chained('base') PathPart('thread/new') Args(0) {
  my ( $self, $c ) = @_;
  $c->detach(qw( PerlFu::Web::Controller::User not_authorized ))
    unless $c->user_exists;
  my $forum  = $c->stash->{'forum'};
  my $params = $c->req->params;
  if ( delete $params->{'submit'} ) {
    $params->{'author'} = $c->user->obj->userid;
    my $validator = $c->model('Validator::Post')->validate($params);
    if ( $validator->results->success ) {
      $c->log->debug("SUCCESS RESULTS");
      my $thread = $forum->create_post({
        title => $validator->results->get_value('title'),
        author => $validator->results->get_value('author'),
        body => $validator->results->get_value('body'),
      });
      if ( !defined( $thread ) ){ 
          $c->log->debug("FUCK");
#      $c->log->debug("THREAD" . defined $thread);
          #     $c->error( $c->messages( $thread, 'error' ) ) 
            # unless defined $thread;
          }
      $c->message( "Created thread " . $thread->postid );
      $c->stash( thread => $thread );
    } else {
      $c->error( $validator->messages );
    }
  }
}

sub reply : Chained('load_thread') PathPart('reply') Args(0) {
  my ( $self, $c ) = @_;
  my $forum  = $c->stash->{'forum'};
  my $thread = $c->stash->{'thread'};
  if ( $c->req->param ) {
    my $reply = $c->model('Database::Post')->create(
      {
        author  => { name => $c->req->param('author') },
        body    => $c->req->param('body'),
        title   => $c->req->param('title'),
        forumid => $forum->forumid,
        parent  => $thread
      }
    );
    $c->stash( reply => $reply );
  }
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
