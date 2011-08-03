package PerlFu::Cmd::Command::load_xml;

use 5.12.0;
use Moose;
use namespace::autoclean;
use File::Find::Rule;
use XML::Toolkit::App;
use Try::Tiny;

extends qw(MooseX::App::Cmd::Command);

has dir => (
  is            => 'rw',
  isa           => 'Str',
  traits        => [qw( Getopt )],
  required      => 1,
  cmd_aliases   => 'd',
  documentation => "specify a directory to grab XML files from.",
);

has app_loader => (
  is      => 'ro',
  isa     => 'XML::Toolkit::App',
  traits  => [qw( NoGetopt )],
  builder => '_build_app_loader',
  lazy    => 1,
);

sub execute {
  my ( $self, $opt, $args ) = @_;
  say "Beginning processing";
  my $dir =  $self->dir;
  my $xml_loader = $self->app_loader->loader;
  my @files = File::Find::Rule->file()
                              ->name('*.xml')
                              ->in($dir);
  for my $file ( @files ) {
    say "Processing $file";
    say "Creating XML::Toolkit object";
    try {
      $xml_loader->parse_file($file) 
        or die "Error parsing: $!";
    } catch {
      say "Whoops, couldn't parse $file: $_";
    };
    say "Completed processing";


  }

}

sub _build_app_loader {
  my $self = shift;
  return XML::Toolkit::App->new( xmlns => { '' => 'PerlFu::XML' } );
}

__PACKAGE__->meta->make_immutable;
1;
