package PerlFu::Web::Controller::Forum;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

PerlFu::Web::Controller::Forum - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub thread : Chained('/') PathPart('forum') CaptureArgs(1) {
  my ($self, $c, $forumid) = @_;
  my $forum = $c->model('Database::Forum')->find($forumid);
  $c->detach('forum_not_found') unless defined $forum;
  $c->stash( forum => $forum );
}

=head2 index

=cut

sub index :Path('/forums') :Args(0) {
    my ( $self, $c ) = @_;
    my @forums = $c->model('Database::Forum')->all;
    $c->stash( forums => \@forums );

}

sub view : Chained('thread') PathPart('') Args(0) {
  my ($self, $c) = @_;
  my $forum = $c->stash->{'forum'};
  my @threads = $forum->threads->all;
  $c->stash( threads => \@threads );
}

sub create : Path('/forum/new') {
  my ($self, $c) = @_;
  my $params = $c->req->params;
  if ( defined $params->{'create'} ) {
    my $forum = $c->model('Database::Forum')->create({
      name => $params->{'name'}
    });
    $c->stash( forum_id => $forum->forumid );
  }
}

sub forum_not_found : Private {
  my ($self, $c) = @_;
  $c->error("Forum was not found");
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
