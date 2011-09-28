package PerlFu::Schema::ResultSet::Post;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub front_page_posts {
  my ($self) = @_;
  $self->search(
    { parent => undef, },
    {
      order_by => { -desc => 'created_at' },
      rows     => 50
    }
  );
}

sub parent_threads {
  my ($self) = @_;
  return $self->search( { parent => undef, }, );
}

sub grandchildren {
  my $self = shift;

  my $path_separator = $self->path_separator;
  my $path_column    = $self->path_column;
  my $id             = $self->id;
  my $like_if_root   = "${id}${path_separator}\%";
  my $like_not_root  = "\%${path_separator}${id}${path_separator}\%";
  return $self->result_source->resultset->search(
    {
      -or => [
        $path_column => { 'like', $like_if_root },
        $path_column => { 'like', $like_not_root },
      ]
    },
    { order_by => { length => $path_column } },
  )->all;
}

1;
