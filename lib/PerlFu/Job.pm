package PerlFu::Job;

use Moose;
use namespace::autoclean;
use MooseX::Storage;
with Storage('format' => 'JSON', 'io' => 'File');

has 'name' => (
  is       => 'rw',
  isa      => 'Str',
  required => 1,
  lazy     => 1,
  default  => sub { die "name required" }
);

has 'params' => (
  is       => 'rw',
  isa      => 'HashRef',
  required => 1,
  lazy     => 1,
  default  => sub { die "job params required" }
);

has 'queue' => (
  is       => 'rw',
  isa      => 'Str',
  required => 1,
  lazy     => 1,
  default  => sub { die "job queue name required" }
);

around name => sub {
  my $orig = shift;
  my $self = shift;
  my $name = $self->$orig;
  $name    = "PerlFu::Job::".$name;
  return $self->$orig($name);
};

sub run {
  my $self = shift;
  my $name = $self->name;
  Class::MOP::load_class($name);
  my $class = $name->new(%{ $self->params });
  $class->run;
}

__PACKAGE__->meta->make_immutable;
1;
