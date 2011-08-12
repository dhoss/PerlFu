package PerlFu::Cmd::Command::load_xml;

use 5.12.0;
use Moose;
use namespace::autoclean;
use File::Find;
use Try::Tiny;
use ElasticSearch;
use Data::Page;
use XML::CompactTree::XS;
use XML::LibXML::Reader;
use Data::Dumper;
extends qw(MooseX::App::Cmd::Command);

has dir => (
  is            => 'rw',
  isa           => 'Str',
  traits        => [qw( Getopt )],
  required      => 1,
  cmd_aliases   => 'd',
  documentation => "specify a directory to grab XML files from.",
  lazy          => 1,
  default       => ".",
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
    Data::Page->new( entries_per_page => 1000 );
  }
);


sub execute {
  my ( $self, $opt, $args ) = @_;
  my $dir = $self->dir;
  say "Getting file list...";
  my @files;
  find( sub { push @files, $File::Find::name if /\.xml$/ }, $dir );
  say "Building data structure...";
  my $pages  = $self->pager;
  my @parsed = $self->build_bulk_data( \@files );
  say "Done parsing...";
  $pages->total_entries( scalar @parsed );
  say "Parsed " . scalar @parsed . " files";
  say "Indexing...";
  my $result;

  for ( $pages->next_page ) {
    my $records = $pages->splice( \@parsed );
    say "****Page: " . $pages->current_page;
    #$result = $self->es->bulk_index($records);
    say "Indexed successfully";
  }

}

sub build_bulk_data {
  my ( $self, $files ) = @_;
  my @file_list = @{$files};
  my @bulk_data;
  my $counter = 0;
  for my $file (@file_list) {
    try {
      $counter += 1;
      say "Parsing $file ($counter of " . scalar @file_list . " files)" . ($counter/(scalar @file_list)) . "% complete";
      open my $fh, "<", $file or die "can't open $file :$!";
      my $contents = do { local $/; <$fh> };
      close $fh;
      say "Read";
      my $reader = XML::LibXML::Reader->new( string => $contents ) 
        || die "can't read file $!";
      say "Read in contents";
      say "creating tree";
      my $tree = XML::CompactTree::XS::readSubtreeToPerl($reader, XCT_DOCUMENT_ROOT|XCT_IGNORE_WS|XCT_IGNORE_COMMENTS);
      say "Set contents";
      #if ( $root->title =~ /(^Permission Denied|user image)/g ) {
      #  warn "Title: " . $root->title;
      #  warn "Node ID: " . $root->id;
      #  next;
      #}
      #my $data = @{ $root->data_collection }[0];
      push @bulk_data, $tree;
      #  {
      #  index => 'perlmonks',
      #  type  => 'perlmonks_node',
      #  data  => {
      #    node => {
      #      title   => $root->title,
      #      author  => @{ $root->author_collection }[0]->text,
      #      id      => $root->id,
      #      content => @{ $data->field_collection }[0]->text,
      #      created => $root->created,
      #      updated => $root->updated,
      #    }
      #  }
      #  };

    }
    catch {
      say "Whoops, couldn't parse $file $_";
    };
  }
  return \@bulk_data;
}

__PACKAGE__->meta->make_immutable;
1;
