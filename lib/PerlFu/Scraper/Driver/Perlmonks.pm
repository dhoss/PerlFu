package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;
use WWW::Mechanize;
use XML::Feed;

sub scrape_action {
  my ($self, $uri) = @_;
  my $rss;
  my @entries;
  $rss = XML::Feed->parse($uri)
    or die XML::Feed->errstr;
  @entries = $rss->entries;
  return \@entries
  
}

1;
