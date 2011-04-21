use strict;
use warnings;
use Test::More;


use Catalyst::Test 'PerlFu::Web';
use PerlFu::Web::Controller::Forum::Thread;

ok( request('/forum/thread')->is_success, 'Request should succeed' );
done_testing();
