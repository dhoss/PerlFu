package PerlFu::Cmd::Command::load_xml;

use 5.12.0;
use Moose;
use namespace::autoclean;
use File::Find::Rule;
use XML::Toolkit::App;
use Try::Tiny;
use Data::Dumper;
use IO::All;

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
  my $dir   = $self->dir;
  my @files = File::Find::Rule->file()->name('*.xml')->in($dir);
  $self->build_bulk_data( \@files );

}

sub build_bulk_data {
  my ( $self, $files ) = @_;
  my @file_list = @{$files};
  my @bulk_data;
  my $xml_loader = $self->app_loader->loader;

  for my $file (@file_list) {
    try {
      my $contents = io($file)->slurp;
      $xml_loader->parse_string($contents);
      my $root = $xml_loader->root_object;
      my $data = @{$root->data_collection}[0];
      warn "GOT FIELD_COLLECTION";
      push @bulk_data, {
        node => {
          title   => $root->title,
          author  => @{$root->author_collection}[0]->text,
          id      => $root->id,
          content => @{$data->field_collection}[0]->text,
          created => $root->created,
          updated => $root->updated,
        }
      };

    }
    catch {
      say "Whoops, couldn't parse $file $_";
      $file . "\n" >> io('failed.log');
    };
    warn Dumper \@bulk_data;
  }
  return \@bulk_data;
}

sub _build_app_loader {
  my $self = shift;
  return XML::Toolkit::App->new( xmlns => { '' => 'PerlFu::XML' } );
}

__PACKAGE__->meta->make_immutable;
1;
