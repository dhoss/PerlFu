package PerlFu::Schema::Result::Post;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw( TimeStamp Tree::NestedSet ));
__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  postid => {
    data_type      => 'integer',
    is_nullable    => 0,
    is_primary_key => 1,
  },
  forumid => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  rootid => { data_type => 'integer', },
  left   => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  right => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  level => {
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
__PACKAGE__->tree_columns(
  {
    root_column  => 'rootid',
    left_column  => 'left',
    right_column => 'right',
    level_column => 'level',
  }
);

1;
