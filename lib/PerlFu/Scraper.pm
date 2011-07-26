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
  my ($self, $uri, $opts) = @_;
  $self->setup;
  $self->scrape_action($uri, $opts);
}
__PACKAGE__->meta->make_immutable;
1;
