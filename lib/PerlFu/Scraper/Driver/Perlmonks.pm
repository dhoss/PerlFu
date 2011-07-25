package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;
use WWW::Mechanize;
use Data::Feed;

has 'www' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default => sub { WWW::Mechanize->new },
);

sub scrape_action {
  my ($self, $uri) = @_;
  my $rss;
  my @entries;
  $rss = Data::Feed->parse($uri);
  @entries = $rss->entries;
  return \@entries
  
}

1;
