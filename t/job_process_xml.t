use strict;
use warnings;
use Test::More;
use Test::Exception;
use PerlFu::Job;
use PerlFu::JobQueue;
use Data::Dumper;
my $job;
my $queue;
lives_ok {
  $job = PerlFu::Job->new( 
    name => 'ProcessXML', 
    params => {
      node_id => 948391
    }, 
    queue => 'perlmonks_xml' 
  );
};

lives_ok {
  $queue = PerlFu::JobQueue->new( name => 'perlmonks_xml' );
};

lives_ok {
  $queue->enqueue($job);
};

my $peek = $queue->peek;
my $expected_peek = '{"__CLASS__":"Moose::Meta::Class::__ANON__::SERIAL::1","params":{"node_id":"948391"},"source":"http://perlmonks.org/?displaytype=xml;","name":"ProcessXML","document":"<?xml version=\\"1.0\\" encoding=\\"windows-1252\\"?>\\n<node id=\\"948391\\" title=\\"Multiple Perl Files, Each With 1 Sub?\\" created=\\"2012-01-17 14:46:37\\" updated=\\"2012-01-17 14:46:37\\">\\n<type id=\\"115\\">\\nperlquestion</type>\\n<author id=\\"590334\\">\\niaw4</author>\\n<data>\\n<field name=\\"doctext\\">\\n&lt;p&gt;I am writing a little website with Mojolicious::Lite (highly recommended, even though the docs are not great, yet;  the package itself is).&lt;/p&gt;\\r\\n\\r\\n&lt;p&gt;I am wondering whether it makes sense to stick each webpage (which is roughly a &lt;code&gt;get \'/webpage\' =&gt; sub { ... }&lt;/code&gt;) into its own .pl file.  because they are more like .pl files than .pm files, I could glob through the directory for .pl files and then concat and eval them.&lt;/p&gt;\\r\\n\\r\\n&lt;p&gt;Numerical Recipees in C/Fortran/etc. organized itself roughly like this, too.&lt;/p&gt;\\r\\n\\r\\n&lt;p&gt;I am probably not the first to run into this issue.  What is the best practice here?&lt;/p&gt;\\r\\n\\r\\n/iaw\\r\\n</field>\\n</data>\\n</node>\\n","queue":"perlmonks_xml"}';
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

END { $queue->flush('perlmonks') };

done_testing;
