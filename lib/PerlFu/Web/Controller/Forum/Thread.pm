package PerlFu::Web::Controller::Forum::Thread;
use Moose;
use namespace::autoclean;
use DBIx::Class::QueryLog;
use DBIx::Class::QueryLog::Analyzer;
use Data::Dumper;
use Try::Tiny;
BEGIN { extends 'PerlFu::Web::Controller::Forum'; }

__PACKAGE__->config(
  { 'Plugin::MessageStack' => { 'model' => 'Validator::Post' } } );

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

  my $forum   = $c->stash->{'forum'};
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
    my $validator = $c->model('Validator')->verify( 'create_thread', $params );

    unless ( $validator->success ) {

      # Catalyst::Plugin::MessageStach integrates with our Data::Manager model
      # and automatically merges the messages
      $c->message(
        {
          type    => "error",
          message => "fix_errors",
        }
      );
      $c->detach();
    }

    my $thread = $forum->create_post(
      {
        title  => $validator->get_value('title'),
        author => $validator->get_value('author'),
        body   => $validator->get_value('body'),
      }
    );

    if ( $thread =~
      /duplicate key value violates unique constraint "posts_title"/ )
    {
      $c->message( { type => "error", message => "post_title_exists" } );
      $c->detach;
    }
    $c->stash( thread => $thread );
  }
}

sub reply : Chained('load_thread') PathPart('reply') Args(0) {
  my ( $self, $c ) = @_;
  my $forum  = $c->stash->{'forum'};
  my $thread = $c->stash->{'thread'};
  my $params = $c->req->params;
  $c->detach(qw( PerlFu::Web::Controller::User not_authorized ))
    unless $c->user_exists;
  if ( delete $params->{'submit'} ) {
    $params->{'parent'} = $thread->postid;
    $params->{'author'} = $c->user->obj->userid;
    my $results = $c->model('Validator')->verify( 'create_reply', $params );
    unless ( $results->success ) {
      $c->message(
        {
          type    => 'error',
          message => 'fix_errors'
        }
      );
      $c->detach();
    }
    my $reply = $forum->create_post(
      {
        author  => { name => $c->user->obj->name },
        body    => $results->get_value('body'),
        title   => $results->get_value('title'),
        forumid => $forum->forumid,
        parent  => $thread
      }
    );
    if ( $reply =~
      /duplicate key value violates unique constraint "posts_title"/ )
    {
      $c->message( { type => "error", message => "post_title_exists" } );
      $c->detach;
    }

    $c->stash( reply => $reply );
  }
}

sub update : Chained('load_thread') PathPart('edit') Args(0) {
  my ( $self, $c ) = @_;
  $c->detach(qw( PerlFu::Web::Controller::User not_authorized ))
    unless $c->user_exists;
  my $thread = $c->stash->{'thread'};
  my $params = $c->req->params;
  my $user = $c->user->obj;
  if ( delete $params->{'submit'} ) {
    $params->{'author'} = $c->user->obj->userid;
    my $results = $c->model('Validator')->verify('create_thread', $params);
    unless ( $results->success ) {
      $c->message({
        type => 'error',
        message => "fix_errors"
      });
      $c->detach();
    }
    my $updated_thread = $thread->update_post({
      title => $results->get_value('title'),
      body  => $results->get_value('body'),
      tags  => $results->get_value('tags'),
    });
    $c->log->debug("THREAD : " .$updated_thread);
    if ( $updated_thread =~
      /duplicate key value violates unique constraint "posts_title"/ )
    {
      $c->message( { type => "error", message => "post_title_exists" } );
      $c->detach;
    }

    $c->stash( thread => $updated_thread, success => 1 );
  }
}

sub delete : Chained('load_thread') PathPart('delete') Args(0) {
  my ($self, $c) = @_;
  $c->detach(qw( PerlFu::Web::Controller::User not_authorized ))
    unless $c->user_exists;
  my $thread = $c->stash->{'thread'};
  my $params = $c->req->params;
  my $user = $c->user->obj;
  
  if ( $params->{'really_delete'} ) {
    $thread->delete;
    $c->stash( deleted => 1 );
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
