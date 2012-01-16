package PerlFu::JobQueue;

use Moose;
use namespace::autoclean;
use Net::Kestrel;

has 'queue' => (
  is       => 'ro',
  isa      => 'Net::Kestrel',
  required => 1,
  lazy     => 1,
  builder  => '_build_queue',
  handler  => qr/.*/,
);


sub _build_queue {
  Net::Kestrel->new
}

__PACKAGE__->meta->make_immutable;
1;
