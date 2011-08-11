use strict;
use warnings;
use Benchmark::Apps;

my $b = Benchmark::Apps->new(
  pretty_print => 1,
  iters        => 400,
);

my %result = $b->run(
  load_and_parse_xml => 'perl -Ilib script/perlfu_ctl.pl load_xml -d root/data/perlmonks/',
);
