#!/usr/bin/env perl

use PerlFu::Scraper;
use Data::Dumper;
use URI;
my $scraper = PerlFu::Scraper->new( driver => "perlmonks" );
# rss: http://perlmonks.org/?node_id=30175;xmlstyle=rss
my $res;

if ( $ARGV[0] eq "-d" ) {
  $res = $scraper->scrape_it($ARGV[1], { directory => 1 });
} else {
  $res = $scraper->scrape_it(URI->new($ARGV[0]));
}
my $num = 0;
for $entry ( @{$res} ) {
  print "Format: " . $entry->format;
  print "Dumper: " . Dumper $entry;
  print "title: " . $entry->title . "\n";
  print "Entry: $num\n";
  $num++;
}
