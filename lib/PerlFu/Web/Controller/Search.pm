package PerlFu::Web::Controller::Search;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

PerlFu::Web::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub perform_search : Path Args(0) {
  my ( $self, $c ) = @_;
  my $params = $c->req->params;
  my $search = $c->model('Search');
  try {
    my $results = $search->searchqs(
      index => 'perlfu',
      type  => ['user', 'article', 'journal', 'comment'],
      q     => $params->{'q'}
    );
    $c->log->debug(Dumper $results);
    my @results;
    for my $hit ( @{ $results->{'hits'}{'hits'} } ) {
      push @results, $hit->{'_source'};
    }
    $c->stash(
      results => \@results,
      query   => $params->{'q'}
    );
  } catch {
    $c->log->debug("ERROR SEARCHING $_");
  }

}

=head1 AUTHOR

,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
