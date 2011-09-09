package PerlFu::Web::Model::Validator::Forum;

use Moose;
use namespace::autoclean;
extends 'PerlFu::Web::Model::Validator';
with 'PerlFu::Web::ScrubsHTML';

sub _build_profile {
  my $self = shift;
  return {
    profile => {
      name => {
        required   => 1,
        type       => 'Str',
        max_length => 255,
        min_length => 1,
        post_check => sub {
          my $r = shift;
          $self->scrub( $r->get_value('name') );
        },
      },
    }
  };
}

__PACKAGE__->meta->make_immutable;
1;
