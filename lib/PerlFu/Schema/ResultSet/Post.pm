package PerlFu::Schema::ResultSet::Post;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub front_page_posts {
  my ($self) = @_;
  $self->search({
    parent => undef,
  },
  {
    order_by => { -desc => 'created_at' },
    rows     => 50
  });
}

sub parent_threads {
  my ($self) = @_;
  return $self->search(
    {
      parent => undef,
    },
  );
}
  


1;
