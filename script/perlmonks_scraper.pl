#!/usr/bin/env perl

use PerlFu::Scraper;
use Data::Dumper;
use URI;
my $scraper = PerlFu::Scraper->new( driver => "perlmonks" );
my $res = $scraper->scrape_it(URI->new("http://perlmonks.org/?node=Seekers%20of%20Perl%20Wisdom"));

print Dumper $res;
