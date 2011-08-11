package PerlFu::Cmd::Command::load_xml;

use 5.12.0;
use Moose;
use namespace::autoclean;
use File::Find::Rule;
use XML::Toolkit::App;
use Try::Tiny;
use Data::Dumper;
use IO::All;
use ElasticSearch;
use Data::Page;

$XML::SAX::ParserPackage = 'XML::LibXML::SAX';

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

has 'es' => (
  is       => 'ro',
  required => 1,
  lazy     => 1,
  traits   => [qw( NoGetopt )],
  default  => sub {
    ElasticSearch->new( servers => '127.0.0.1:9200', );
  },
);

has 'pager' => (
  is       => 'ro',
  required => 1,
  lazy     => 1,
  traits   => [qw( NoGetopt )],
  default  => sub {
    Data::Page->new( entries_per_page => 5000 );
  }
);

sub execute {
  my ( $self, $opt, $args ) = @_;
  my $dir = $self->dir;
  say "Getting file list...";
  my @files = File::Find::Rule->file()->name('*.xml')->in($dir);
  say "Building data structure...";
  my $pages = $self->pager;
  my @parsed = $self->build_bulk_data( \@files );
  $pages->total_entries(scalar @parsed);
  say Dumper \@parsed;
  say "Indexing...";
  my $result;
  for ( $pages->next_page ) {
    warn "INSIDE";
    my $records = $pages->splice( \@parsed );
    say "****Page: " . $pages->current_page;
    io('records.txt') < Dumper $records;
    $result = $self->es->bulk_index( $records );
    say "Indexed successfully";
    Dumper $records > io('records.txt');
  }

}

sub build_bulk_data {
  my ( $self, $files ) = @_;
  my @file_list = @{$files};
  my @bulk_data;
  my $xml_loader = $self->app_loader->loader;

  for my $file (@file_list) {
    try {
      say "Parsing $file";
      my $contents = io($file)->slurp;
      eval { $xml_loader->parse_string($contents) };
      next if $@;
      my $root = $xml_loader->root_object;
      if ( $root->title =~ /(^Permission Denied|user image)/g ) {
        warn "Title: " . $root->title;
        warn "Node ID: " . $root->id;
        next;
      }
      my $data = @{ $root->data_collection }[0];
      push @bulk_data,
      {
        index => 'perlmonks',
        type  => 'perlmonks_node',
        data  => {
          node => {
            title   => $root->title,
            author  => @{ $root->author_collection }[0]->text,
            id      => $root->id,
            content => @{ $data->field_collection }[0]->text,
            created => $root->created,
            updated => $root->updated,
          }
        }
      };

    }
    catch {
      say "Whoops, couldn't parse $file $_";
    };
  }
  return \@bulk_data;
}

sub _build_app_loader {
  my $self = shift;
  return XML::Toolkit::App->new( xmlns => { '' => 'PerlFu::XML' } );
}

__PACKAGE__->meta->make_immutable;
1;
