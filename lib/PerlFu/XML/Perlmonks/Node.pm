package PerlFu::XML::Perlmonks::Node;

use Moose::Role;
use namespace::autoclean;
use PerlFu::XML::Parser;
use LWP::UserAgent;
use HTTP::Request::Common;

has 'document' => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_document',
);

has 'source' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => "http://perlmonks.org/?displaytype=xml;"
);

has 'ua' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub { LWP::UserAgent->new }
);

has 'parser' => (
  is       => 'ro',
  required => 1,
  lazy     => 1,
  default  => sub { PerlFu::XML::Parser->new }
);

sub _build_document {
  my $self   = shift;
  my $ua     = $self->ua;
  my $params = $self->params;
  my $node_url = $self->source .
                 "node_id="    . 
                 $params->{'node_id'};
  my $res      = $ua->request( GET $node_url );
  return $res->content;
}

sub build_hash {
  my $self = shift;
  my $contents = $self->document;
  my @nodes     = $self->build_xml_nodes($contents);
  my $tree;
  $tree->{'node_data'} = $nodes[0][2][0][3];
  $tree->{'author_id'} = $nodes[0][2][0][4][3][3]->{'id'};
  $tree->{'body'}      = $nodes[0][2][0][4][5][4][1][4][0][1];
  return $tree;
}
  
1;
