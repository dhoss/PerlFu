package PerlFu::Web::Controller::Forum;
use Moose;
use namespace::autoclean;
use Try::Tiny;

BEGIN {extends 'Catalyst::Controller::REST'; }

=head1 NAME

PerlFu::Web::Controller::Forum - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('/') PathPart('') CaptureArgs(0) {}

sub object_with_id : Chained('base') PathPart('') CaptureArgs(1) {
  my ( $self, $c, $forumid ) = @_;
  my $forum = $c->model('Database::Forum')->find($forumid);
  $c->stash( forum => $forum );
}

sub object_without_id : Chained('base') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  my $forums = $c->model('Database::Forum')->all;
  $c->stash( forums => $forums );
}


sub list : Chained('object_without_id') PathPart('forums') Args(0) {
    my ( $self, $c ) = @_;

}

sub create : Chained('object_without_id') PathPart('forum/new') Args(0) {
  my ($self, $c) = @_;
  my $params = $c->req->params;
  if ( delete $params->{'submit'} ) {
    my $validator = $c->model('Validator::Forum')->validate($params);
    if ( $validator->results->success ) { 
      # put me in the resultsource class
      my $forum = $c->model('Database')->txn_do(sub {
        try {
          if ( $c->model('Database::Forum')->find({ name => $validator->results->get_value('name') }) ) {
            die $c->message("Forum name exists" , 'error');
          }
          my $f = $c->model('Database::Forum')->create({
            name => $validator->results->get_value('name')
          });
          $f;
        } catch { 
          $c->log->debug($_);
          $c->error($c->messages($_, 'error'));
        };
      });
      $c->message("Created forum " . $forum->forumid);
    } else {
      $c->error($validator->messages);
    }
  }
}

sub read : Chained('object_with_id') PathPart('forum') Args(0) {
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
