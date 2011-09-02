package PerlFu::Schema::Result::User;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw( TimeStamp ));
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
  userid => {
    data_type      => 'integer',
    is_nullable    => 0,
    is_primary_key => 1,
    is_auto_increment => 1,
  },
  name => {
    data_type   => 'varchar',
    size        => '255',
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key('userid');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many(
  'posts' => 'PerlFu::Schema::Result::Post',
  { 'foreign.author' => 'self.userid', }
);
1;
