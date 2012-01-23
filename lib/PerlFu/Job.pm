package PerlFu::Job;

use Moose;
use namespace::autoclean;
use MooseX::Storage;
use Moose::Util qw( apply_all_roles );
use Data::Dumper;

with Storage(
  'format' => 'JSON', 
  'io' => 'File',
);

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
  default  => sub{ {} }
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
  return $name;
};

sub BUILD {
  my $self = shift;
  my $name = $self->name;
  apply_all_roles($self, $name);
}

__PACKAGE__->meta->make_immutable;
1;
