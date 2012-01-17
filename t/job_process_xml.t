use strict;
use warnings;
use Test::More;
use Test::Exception;
use PerlFu::Job;
use PerlFu::JobQueue;

my $job;
my $queue;
lives_ok {
  $job = PerlFu::Job->new( 
    name => 'ProcessXML', 
    params => {}, 
    queue => 'herp' 
  );
};

lives_ok {
  $queue = PerlFu::JobQueue->new( name => 'herp' );
};

lives_ok {
  $queue->enqueue($job);
};

my $peek = $queue->peek;
my $expected_peek = '{"__CLASS__":"PerlFu::Job","params":{},"name":"ProcessXML","queue":"herp"}';

ok $peek eq $expected_peek , "queue has what it should have";

my $job_code;
lives_ok {
  $job_code = $queue->dequeue;
};

lives_ok { 
  $job_code->run;
};

lives_ok {
  $queue->confirm;
};

ok !$queue->peek, "queue has nothing";

done_testing;
