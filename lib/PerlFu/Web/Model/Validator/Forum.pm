package PerlFu::Web::Model::Validator::Forum;

use Moose;
use namespace::autoclean;

sub _build_profile { 
  return {
    name => {
      required => 1,
      type     => 'Str',
      max_length => 255,
      min_length => 1,
    }
  };
}

__PACKAGE__->meta->make_immutable;
1;
