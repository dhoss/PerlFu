use strict;
use warnings;
use Test::More;
use Test::Exception;
use PerlFu::JobQueue::Job::ProcessXML;

my $job;

lives_ok {
  $job = PerlFu::JobQueue::Job::ProcessXML->new( name => 'huehue', params => {}, queue => 'derp' );
};

lives_ok {
  $job->enqueue
};
done_testing;
