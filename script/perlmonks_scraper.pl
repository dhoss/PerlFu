#!/usr/bin/env perl

use PerlFu::Scraper;
use Data::Dumper;
use URI;
my $scraper = PerlFu::Scraper->new( driver => "perlmonks" );
my $res = $scraper->scrape_it(URI->new("http://perlmonks.org/?node_id=30175;xmlstyle=rss;types=perlquestion"));

print Dumper $res;
