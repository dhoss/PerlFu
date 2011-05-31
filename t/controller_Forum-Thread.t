use strict;
use warnings;
use Test::More;

{

  package Forum::Thread::Tests;
  use base qw(Test::Class);
  use Test::More;
  use PerlFu::Schema;
  use Catalyst::Test 'PerlFu::Web';
  use PerlFu::Web::Controller::Forum::Thread;

  sub schema {
    PerlFu::Schema->connect( 'dbi:SQLite::memory:', '', '' );
  }

  # setup methods are run before every test method.
  sub make_fixture : Test(setup) {
    my $schema = schema();
    $schema->deploy;
    my $user = $schema->resultset('User')->create( { name => 'turd_face' } )
      or die "Can't create user: $!";
    diag("Created user");
  }

  sub test_basic_request : Test {
    ok( request('/forum/thread')->is_success, 'Request should succeed' );
  }

#  sub teardown : Test(teardown) {
#    my $schema = schema();
#    $schema->resultset('User')->find( { name => 'turd_face' } )->delete;
#    diag("Deleted user");
#  }

}

Test::Class->runtests;
