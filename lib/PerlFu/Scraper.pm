package PerlFu::Scraper;

use Moose;
use namespace::autoclean;

has 'driver' => (
  is       => 'rw',
  lazy     => 1,
  required => 1,
   default => sub { die "driver class name required" }
);

with 'PerlFu::Scraper::Driver';



sub scrape_it {
  my ($self, $uri) = @_;
  $self->setup;
  $self->scrape_action->scrape($uri);
}

1;
