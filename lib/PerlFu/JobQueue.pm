package PerlFu::JobQueue;

use Moose;
use namespace::autoclean;
use Net::Kestrel;
use Data::Dumper;

has 'name' => (
  is       => 'rw',
  isa      => 'Str',
  required => 1,
  lazy     => 1,
  default  => sub { die "queue name required" }
);

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

sub enqueue {
  my ($self, $job) = @_;
  my $kes = $self->kestrel;
  my $packed_job = $job->freeze;
  $kes->put( $self->name, $packed_job );
}

sub dequeue {
  my $self = shift;
  my $kes = $self->kestrel;
  my $job = $kes->get( $self->name );
  return PerlFu::Job->thaw($job);
}

around confirm => sub {
  my $orig = shift;
  my $self = shift;
  my $queue = $self->name;
  my $kes = $self->kestrel;
  $kes->confirm($queue, 1);
};
 
around peek => sub {
  my $orig = shift;
  my $self = shift;
  my $queue = $self->name;
  my $kes = $self->kestrel;
  $kes->peek($queue);
};

__PACKAGE__->meta->make_immutable;
1;
