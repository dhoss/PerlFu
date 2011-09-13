package PerlFu::Schema::Result::Forum;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw( TimeStamp ));
__PACKAGE__->table('forums');
__PACKAGE__->add_columns(
  forumid => {
    data_type => 'integer',
    is_nullable => 0,
    is_auto_increment => 1,
  },
  name => {
    data_type => 'varchar',
    size => '255',
    is_nullable => 0,
  },
);

__PACKAGE__->set_primary_key('forumid');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many('threads' => 'PerlFu::Schema::Result::Post',
  {
    'foreign.forumid' => 'self.forumid'
  }
);

sub sqlt_deploy_hook {
  my ($self, $sqlt_table) = @_;
  $sqlt_table->add_index(
    name => 'forum_name_idx',
    fields => ['forumid', 'name']
  );
}



1;
