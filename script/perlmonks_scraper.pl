#!/usr/bin/env perl

use PerlFu::Scraper;
use Data::Dumper;
use URI;
my $scraper = PerlFu::Scraper->new( driver => "perlmonks" );
my $res = $scraper->scrape_it(URI->new("http://perlmonks.org/?node_id=30175;xmlstyle=rss"));
my $num = 0;
for $entry ( @{$res} ) {
  print "Format: " . $entry->format;
  print "Dumper: " . Dumper $entry;
  print "title: " . $entry->title . "\n";
  print "Entry: $num\n";
  $num++;
}
