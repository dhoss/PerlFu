package PerlFu::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=head1 NAME

PerlFu::Web::Controller::Root - Root Controller for PerlFu::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
  my ( $self, $c ) = @_;
  my @front_page_posts = $c->model('Database::Post')->front_page_posts->all;
  $c->stash( posts => \@front_page_posts );
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
  my ( $self, $c ) = @_;
  $c->response->body('Page not found');
  $c->response->status(404);
}

sub notauthorized :Path {
  my ( $self, $c ) = @_;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : Private {
  my ( $self, $c ) = @_;
  if ( scalar @{ $c->error } ) {
    $c->stash->{errors} = $c->error;
    $c->forward('PerlFu::Web::View::HTML');
    $c->clear_errors;
  }

  return 1 if $c->response->status =~ /^3\d\d$/;
  return 1 if $c->response->body;

  unless ( $c->response->content_type ) {
    $c->response->content_type('text/html; charset=utf-8');
  }

  $c->forward('PerlFu::Web::View::HTML');
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
