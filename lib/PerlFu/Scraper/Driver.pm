package PerlFu::Scraper::Driver;

use Moose::Role;
use namespace::autoclean;
requires 'driver';

sub setup {
  my $self = shift;
  my $class = "PerlFu::Scraper::Driver::". ucfirst $self->driver;
  Class::MOP::load_class($class);
  $class->meta->apply($self) unless $self->does($class); 
}

1;
