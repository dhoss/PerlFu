use strict;
use warnings;
use Test::More;
use Test::Exception;
use PerlFu::JobQueue;

my $jq;
my $thing;
lives_ok { 
  $jq = PerlFu::JobQueue->new;
  $jq->put('herp', 'derp');
  $thing = $jq->get('herp');
  $jq->confirm('herp', 1);
};

ok $thing eq 'derp', "got the correct thing out of the queue";
done_testing;
