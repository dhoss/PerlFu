package PerlFu::Web::Controller::Forum::Thread;
use Moose;
use namespace::autoclean;

BEGIN {extends 'PerlFu::Web::Controller::Forum'; }

=head1 NAME

PerlFu::Web::Controller::Forum::Thread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('.') PathPart('thread') CaptureArgs(1) {
  my ($self, $c, $threadid) = @_;
  my $thread = $c->model('Database::Post')->find($threadid);
  $c->detach('thread_not_found') unless defined $thread;
  $c->stash( thread => $thread );
}

sub base_plural : Chained('.') PathPart('threads') CaptureArgs(0) {
  my ($self, $c) = @_;
} 

=head2 index

=cut

sub index : Chained('base_plural') PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  
  my $forum = $c->stash->{'forum'};
  my @threads = $forum->threads->all;
  $c->stash( threads => \@threads);

}


sub view : Chained('base') Pathpart('') Args(0) {
  my ($self, $c) = @_;
}

sub thread_not_found : Private {
  my ($self, $c) = @_;
  $c->error("No such thread");
}

sub create : Chained('base_plural') PathPart('new') Args(0) {
  my ($self, $c) = @_;
  my $forum = $c->stash->{'forum'};
  if ( $c->req->param ) {
    my $thread = $forum->add_to_threads({
      author => { name => $c->req->param('author') },
      title  => $c->req->param('title'),
      body   => $c->req->param('body'),
    })
      or die "can't create thread $!";
    $c->stash(
      thread => $thread
    );
    return;
  }
}

sub reply : Chained('base') PathPart('reply') Args(0) {
  my ($self, $c)  = @_;
  my $forum = $c->stash->{'forum'};
  my $thread = $c->stash->{'thread'};
  if ( $c->req->param ) {
    my $reply = $thread->add_to_children({
      author => { name => $c->req->param('author') },
      body => $c->req->param('body'),
      title => 'RE:' . $thread->title,
      forumid => $forum->forumid,
    });
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
