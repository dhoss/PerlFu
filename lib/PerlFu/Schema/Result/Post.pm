package PerlFu::Schema::Result::Post;

use parent qw( DBIx::Class::Core );
use Try::Tiny;

__PACKAGE__->load_components(qw( TimeStamp +DBICx::MaterializedPath ));
__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  postid => {
    data_type         => 'integer',
    is_nullable       => 0,
    is_primary_key    => 1,
    is_auto_increment => 1,
  },
  forumid => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  title => {
    data_type   => 'varchar',
    is_nullable => 0,
    size        => '200',
  },
  tags => {
    data_type   => 'varchar',
    is_nullable => 1,
    size        => '255',
  },
  body => {
    data_type   => 'text',
    is_nullable => 0,
  },
  author => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  parent => {
    data_type   => 'integer',
    is_nullable => 1,
  },
  path => {
    data_type   => 'varchar',
    is_nullable => 1,
    size        => 255,
  },
  created_at => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
  },
  updated_at => {
    data_type => 'datetime',
    is_nullable => 1,
    set_on_update => 1,
    set_on_create => 1,
  }
);

__PACKAGE__->parent_column("parent");
__PACKAGE__->path_column("path");
__PACKAGE__->path_separator('.');
__PACKAGE__->set_primary_key('postid');
__PACKAGE__->add_unique_constraint( ['title'] );

__PACKAGE__->belongs_to(
  'forum' => 'PerlFu::Schema::Result::Forum',
  { 'foreign.forumid' => 'self.forumid', }
);

__PACKAGE__->belongs_to(
  'author' => 'PerlFu::Schema::Result::User',
  { 'foreign.userid' => 'self.author', }
);

__PACKAGE__->belongs_to(
  parent => __PACKAGE__,
  { postid    => "parent" },
  { join_type => "LEFT" },
);

__PACKAGE__->has_many(
  children => __PACKAGE__,
  { "foreign.parent" => "self.postid" },
);

sub reply_count {
  my $self = shift;
  return $self->children->count;
}

sub update_post {
  my ( $self, $params ) = @_;
  my $post;
  my $exception;
  try {
    $post = $self->result_source->schema->txn_do(
      sub {
        $self->update($params);
      }
    );
  } catch {
    $exception = $_;

    #  if ( $_ =~ /Rollback failed/ );
  };
  return $exception if $exception;
  return $post;
}

sub sqlt_deploy_hook {
  my ($self, $sqlt_table) = @_;
  $sqlt_table->add_index(
    name => 'path_postid_idx',
    fields => ['path', 'postid']
  );
  $sqlt_table->add_index(
    name => 'post_author_idx',
    fields => ['postid', 'author']
  );
  $sqlt_table->add_index(
    name => 'path_idx',
    fields => ['path']
  );
}

1;
