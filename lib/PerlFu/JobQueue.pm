package PerlFu::JobQueue;

use Moose;
use namespace::autoclean;
use Net::Kestrel;

has 'kestrel' => (
  is       => 'ro',
  isa      => 'Net::Kestrel',
  required => 1,
  lazy     => 1,
  builder  => '_build_kestrel',
  handles  => qr/.*/,
);

sub _build_kestrel {
  Net::Kestrel->new
}


__PACKAGE__->meta->make_immutable;
1;
