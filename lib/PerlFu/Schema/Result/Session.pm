package PerlFu::Schema::Result::Session;

use parent qw( DBIx::Class::Core );

__PACKAGE__->table('sessions');
__PACKAGE__->add_columns(
  id => {
    data_type      => 'char',
    is_nullable    => 0,
    is_primary_key => 1,
    size           => 72
  },
  session_data => {
    data_type   => 'text',
    is_nullable => 1,
  },
  expires => {
    data_type => 'integer',
    is_nullable => 1
  }
);

__PACKAGE__->set_primary_key('id');
1;
