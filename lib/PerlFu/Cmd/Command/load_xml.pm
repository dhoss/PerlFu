package PerlFu::Cmd::Command::load_xml;

use 5.12.0;
use Moose;
use namespace::autoclean;
use Path::Class qw( dir file );
use XML::Toolkit::Loader;

extends qw(MooseX::App::Cmd::Command);

has dir => (
  is            => 'rw',
  isa           => 'Str',
  traits        => [qw( Getopt )],
  required      => 1,
  cmd_aliases   => 'd',
  documentation => "specify a directory to grab XML files from.",
);

has loader => (
  is      => 'ro',
  isa     => 'XML::Toolkit::Loader',
  traits  => [qw( NoGetopt )],
  builder => '_build_loader',
  lazy    => 1,
);

sub execute {
  my ( $self, $opt, $args ) = @_;
  say "Beginning processing";
  my $dir_handle = dir($self->dir)
    or die "Can't open " . $self->dir->stringify . " : $!";
  while ( my $file = $dir_handle->next ) {
    say "Processing $file";

  }

}

sub _build_loader {
  my $self = shift;
  return XML::Toolkit::Loader->new;
}

__PACKAGE__->meta->make_immutable;
1;
