package PerlFu::Schema::Result::Role;

use parent qw( DBIx::Class::Core );

__PACKAGE__->table('roles');
__PACKAGE__->add_columns(
  roleid => {
    data_type      => 'integer',
    is_nullable    => 0,
    is_primary_key => 1,
  },
  name => {
    data_type   => 'varchar',
    size        => '255',
    is_nullable => 0,
  },
 
);

__PACKAGE__->set_primary_key('roleid');
__PACKAGE__->add_unique_constraint( ['name'] );
__PACKAGE__->has_many(
  'users' => 'PerlFu::Schema::Result::UserRole',
  { 'foreign.roleid' => 'self.roleid', }
);
1;
