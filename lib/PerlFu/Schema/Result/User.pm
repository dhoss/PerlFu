package PerlFu::Schema::Result::User;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw( TimeStamp EncodedColumn ));
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
  userid => {
    data_type      => 'integer',
    is_nullable    => 0,
    is_primary_key => 1,
  },
  name => {
    data_type   => 'varchar',
    size        => '255',
    is_nullable => 0,
  },
  password => {
    data_type           => 'char',
    size                => 59,
    encode_column       => 1,
    encode_class        => 'Crypt::Eksblowfish::Bcrypt',
    encode_args         => { key_nul => 0, cost => 8 },
    encode_check_method => 'check_password'
  },
);

__PACKAGE__->set_primary_key('userid');
__PACKAGE__->add_unique_constraint( ['name'] );
__PACKAGE__->has_many(
  'posts' => 'PerlFu::Schema::Result::Post',
  { 'foreign.author' => 'self.userid', }
);
1;
