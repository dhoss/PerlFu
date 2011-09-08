package PerlFu::Schema::Result::UserRole;

use parent qw( DBIx::Class::Core );

__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(
  roleid => {
    data_type      => 'integer',
    is_nullable    => 0,
  },
  userid => {
    data_type   => 'integer',
    is_nullable => 0,
  },
 
);

__PACKAGE__->set_primary_key(qw( roleid userid ));
__PACKAGE__->belongs_to(
  'user' => 'PerlFu::Schema::Result::User',
  { 'foreign.userid' => 'self.userid', }
);
__PACKAGE__->belongs_to(
  'role' => 'PerlFu::Schema::Result::Role',
  { 'foreign.roleid' => 'self.roleid' }
);
1;
