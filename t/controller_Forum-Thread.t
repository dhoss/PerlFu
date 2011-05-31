use strict;
use warnings;
use Test::More;
BEGIN { $ENV{'PERLFU_WEB_CONFIG_LOCAL_SUFFIX'} = 'test' }
{

  package Forum::Thread::Tests;
  use base qw(Test::Class);
  use Test::More;
  use PerlFu::Schema;
  use Catalyst::Test 'PerlFu::Web';
  use PerlFu::Web::Controller::Forum::Thread;
  BEGIN { $ENV{'PERLFU_WEB_CONFIG_LOCAL_SUFFIX'} = 'test' }
  sub schema {
    PerlFu::Schema->connect( 'dbi:SQLite:perlfu_test.db', '', '' );
  }

  # setup methods are run before every test method.
  sub make_fixture : Test(setup) {
    my $schema = schema();
    $schema->deploy( { add_drop_table => 1 } );
    my $user = $schema->resultset('User')->create( { name => 'turd_face' } )
      or die "Can't create user: $!";
    diag("Created user");
    my $forum = $schema->resultset('Forum')->create( { name => 'test forum' } )
      or die "Can't create forum: $!";
    diag( "Created forum " . $forum->forumid );
    my $thread = $forum->create_related(
      'threads',
      {
        title  => 'first thread',
        author => $user->userid,
        body   => 'test thread'
      }
    ) or die "can't create thread $!";
    diag( "Created thread " . $thread->title );
  }

  sub test_basic_request : Test {
    ok( request('/forum/1/thread/1')->is_success, 'Request should succeed' );
  }

  sub teardown : Test(teardown) {
    my $schema = schema();
    $schema->resultset('User')->find( { name => 'turd_face' } )->delete
      or die "Can't delete user $!";
    diag("Deleted user");
    $schema->resultset('Forum')->find( { name => 'test forum' } )->delete
      or die "Can't delete forum $!";
    diag "Deleted forum";
  }

}

Test::Class->runtests;
