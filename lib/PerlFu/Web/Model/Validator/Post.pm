package PerlFu::Web::Model::Validator::Post;

use Moose;
use namespace::autoclean;
extends 'PerlFu::Web::Model::Validator';

sub _build_profile {
  my $self = shift;
  return {
    profile => {
      name => {
        required   => 1,
        type       => 'Str',
        max_length => 255,
        min_length => 1,
      },
    }
  };
}

__PACKAGE__->meta->make_immutable;
1;
