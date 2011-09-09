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

sub create : Chained('base') PathPart('new') Args(0) {
  my ($self, $c) = @_;
  my $params = $c->req->params;
  if ( delete $params->{'submit'} ) {
    my $results = $c->model('Validator::Forum')->results($params);
    if ( $results->success ) { 
      my $forum = $c->model('Database')->txn_do(sub {
        try {
          my $f = $c->model('Database::Forum')->create({
            name => $results->get_value('name')
          }) or die $!;
        } catch { 
          $c->error($_);
        };
      });
    } else {
      $c->error($results->errors);
    }
  }
}

sub read : Chained('thread') PathPart('') Args(0) {
  my ($self, $c) = @_;
  my $forum = $c->stash->{'forum'};
  my @threads = $forum->threads->parent_threads;
  
  $c->stash( threads => \@threads );
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
