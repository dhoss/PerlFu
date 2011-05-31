package PerlFu::Schema::Result::Post;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw( TimeStamp +DBICx::MaterializedPath ));
__PACKAGE__->parent_column("parent"); # default "parent"
__PACKAGE__->path_column("path");     # default "materialized_path"
__PACKAGE__->path_separator(".");     # default "/"

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  postid => {
    data_type      => 'integer',
    is_nullable    => 0,
    is_primary_key => 1,
    is_auto_increment => 1,
  },
  forumid => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  parent => { 
    data_type => 'integer', 
    is_nullable => 1,
  },
  path   => {
    data_type   => 'varchar',
    size        => 255,
    is_nullable => 1,
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
);

__PACKAGE__->set_primary_key('postid');
__PACKAGE__->add_unique_constraint(['title']);
__PACKAGE__->belongs_to( 'forum' => 'PerlFu::Schema::Result::Forum',
  {
    'foreign.forumid' => 'self.forumid',
  }
);

__PACKAGE__->belongs_to(
  'author' => 'PerlFu::Schema::Result::User',
  { 'foreign.userid' => 'self.author', }
);

sub sqlt_deploy_hook { 
  $_[1]->add_index(
    name => "posts_idx_parent",
    fields => ['parent'],
  );
}
  
1;
