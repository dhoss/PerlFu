package PerlFu::Web::Controller::Forum::Thread;
use Moose;
use namespace::autoclean;
use DBIx::Class::QueryLog;
use DBIx::Class::QueryLog::Analyzer;
use Data::Dumper;
BEGIN { extends 'PerlFu::Web::Controller::Forum'; }

=head1 NAME

PerlFu::Web::Controller::Forum::Thread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub load_thread : Chained('base') PathPart('thread') CaptureArgs(1) {
  my ( $self, $c, $threadid ) = @_;
  $c->log->debug("*** GETTING POST ***");
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
  $c->log->debug( "*** GETTING ALL THREADS IN FORUM " . $forum->name );
  my @threads =
    $forum->threads->parent_threads;
  $c->stash( threads => \@threads );

}

sub read : Chained('load_thread') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub thread_not_found : Private {
  my ( $self, $c ) = @_;
  $c->error("No such thread");
}

sub create : Chained('base') PathPart('new') Args(0) {
  my ( $self, $c ) = @_;
  my $forum = $c->stash->{'forum'};
  if ( $c->req->param ) {
    $c->log->debug( "*** CREATING THREAD " . $c->req->param('title') );
    my $thread = $forum->add_to_threads(
      {
        author => { name => $c->req->param('author') },
        title  => $c->req->param('title'),
        body   => $c->req->param('body'),
      }
    ) or die "can't create thread $!";
    $c->stash( thread => $thread );
    return;
  }
}

sub reply : Chained('load_thread') PathPart('reply') Args(0) {
  my ( $self, $c ) = @_;
  my $forum  = $c->stash->{'forum'};
  my $thread = $c->stash->{'thread'};
  if ( $c->req->param ) {
    $c->log->debug( "*** CREATING REPLY TO " . $thread->title );
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
    return;
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
