#!/usr/bin/env perl

use PerlFu::Scraper;
use Data::Dumper;
use URI;
my $scraper = PerlFu::Scraper->new( driver => "perlmonks" );
# rss: http://perlmonks.org/?node_id=30175;xmlstyle=rss
my $res;

if ( $ARGV[0] eq "-d" ) {
  $res = $scraper->run($ARGV[1], { directory => 1 });
} else {
  $res = $scraper->run(URI->new($ARGV[0]));
}
