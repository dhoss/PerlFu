package PerlFu::XML::Perlmonks::NewestNodes;

use 5.12.0;
use Moose::Role;
use namespace::autoclean;
use PerlFu::XML::Parser;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Dumper;

has 'document' => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_document',
);

has 'source' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => "http://perlmonks.org/?node=Newest%20Nodes%20XML%20Generator"
);

has 'ua' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub {
    say "Building LWP";
    LWP::UserAgent->new;
  }
);

has 'parser' => (
  is       => 'ro',
  required => 1,
  lazy     => 1,
  default  => sub {
    say "Building parser";
    PerlFu::XML::Parser->new;
  }
);

sub _build_document {
  my $self     = shift;
  my $ua       = $self->ua;
  my $node_url = $self->source;
  say "Getting content";
  my $res = $ua->request( GET $node_url );
  return $res->content;
}

sub nodes {
  my $self          = shift;
  my $contents      = $self->document;
  my $parser        = $self->parser;
  my $all_xml_nodes = $parser->build_xml_nodes($contents);
  my @nodes;
  # up to this index in the array is a bunch of non-crucial data, 
  # [4] is the beginning of the array of node data
  my $nodes = $all_xml_nodes->[0][2][0][4];
  for ( @{$nodes} ) {
    # skip it if it's author data
    # or whatever the non-word stuff is
    next if $_->[1] eq 'AUTHOR' || 
            $_->[1] !~ /\w+/;
    # [3] is the actual node data
    push @nodes, $_->[3];
  }
  return \@nodes;
}

1;
