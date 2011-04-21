use strict;
use warnings;
use Test::More;


use Catalyst::Test 'PerlFu::Web';
use PerlFu::Web::Controller::Forum;

ok( request('/forum')->is_success, 'Request should succeed' );
done_testing();
