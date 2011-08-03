package PerlFu::Scraper;

use Moose;
use namespace::autoclean;
use File::Find::Rule;

has 'driver' => (
  is       => 'rw',
  lazy     => 1,
  required => 1,
  default  => sub { die "driver class name required" }
);

has 'rule' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub {
    File::Find::Rule->new->file();
  }
);


with 'PerlFu::Scraper::Driver';

sub scrape_it {
  my ( $self, $uri, $opts ) = @_;
  $self->setup;
  $self->scrape_action( $uri, $opts );
}

__PACKAGE__->meta->make_immutable;
1;
