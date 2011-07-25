package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;

use Data::Feed;

sub scrape_action {
  my ($self, $uri) = @_;

  my $rss = Data::Feed->parse($uri);
  my @entries = $rss->entries;
  return \@entries
  
}

1;
