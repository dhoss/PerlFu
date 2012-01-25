use strict;
use warnings;
use PerlFu::Job;
use PerlFu::JobQueue;
use Data::Dumper;
my $job;
my $queue;
$job = PerlFu::Job->new(
  name   => 'ProcessXML',
  params => { 
    type => "Perlmonks::NewestNodes",
  },
  queue  => 'perlmonks'
);

$queue = PerlFu::JobQueue->new( name => 'perlmonks' );
$queue->enqueue($job);

my $job_code;
$job_code = $queue->dequeue;
$job_code->run;

$queue->confirm;

