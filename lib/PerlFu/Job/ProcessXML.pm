package PerlFu::Job::ProcessXML;

use Moose::Role;
use namespace::autoclean;
use XML::CompactTree::XS;
use XML::LibXML::Reader;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Dumper;

requires 'run';

has 'document' => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_document',
);

has 'base_url' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => "http://perlmonks.org/?displaytype=xml;"
);

before run => sub{ 
  my $self = shift;
  my $contents = $self->document;
  my $reader   = XML::LibXML::Reader->new( string => $contents )
    || die "can't read file $!";
  my @nodes     = $self->build_xml_tree($reader);
  warn Dumper $nodes[0];
};

sub _build_document {
  my $self   = shift;
  my $ua         = LWP::UserAgent->new;
  my $params = $self->params;
  my $node_url = $self->base_url .
                 "node_id="     . 
                 $params->{'node_id'};
  my $res      = $ua->request( GET $node_url );
  return $res->content;

}

sub build_xml_tree {
  my ( $self, $reader ) = @_;
  my @ns_map;
  my %ns;
  my $tree =
    XML::CompactTree::XS::readSubtreeToPerl( 
      $reader,
      XCT_DOCUMENT_ROOT,
      \%ns 
  );
  $ns_map[ $ns{$_} ] = $_ for keys %ns;
  my @nodes = ($tree);

}


1;
