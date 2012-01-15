package PerlFu::Cmd::Command::get_node_ids;

use 5.12.0;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use XML::CompactTree::XS;
use XML::LibXML::Reader;
use Net::Kestrel;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Dumper;

extends qw(MooseX::App::Cmd::Command);

has 'id' => (
  is      => 'ro',
  lazy    => 1,
  default => 1
);

has next_id => (
  is      => 'rw',
  lazy    => 1,
  builder => '_build_next_id',
);

has 'ticker_url' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => "http://perlmonks.org/?node_id=693598"
);

has 'queue' => (
  is       => 'ro',
  isa      => 'Net::Kestrel',
  required => 1,
  builder  => '_build_queue',
  handles  => qr/^.*/,
);

has 'ua' => (
  is       => 'ro',
  required => 1,
  lazy     => 1,
  default  => sub {
    return LWP::UserAgent->new;
  }
);

has 'document' => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_docuent',
);

sub _build_queue {
  Net::Kestrel->new;
}

sub _build_next_id {
  my ($self, $id)     = @_;
  return $id
}

sub _build_document {
  my $self = shift;

}

sub execute {
  my ($self) = @_;
  my $ua       = $self->ua;
  my $res      = $ua->request( GET $self->ticker_url . ";id=1" );
  my $contents = $res->content;
  my $reader   = XML::LibXML::Reader->new( string => $contents )
    || die "can't read file $!";
  my @nodes     = $self->build_xml_tree($reader);
  my $next_node = $nodes[0][2][0][4][3][4][0][3];
  $self->next_id($next_node->{'node_id'});

  say $self->next_id

}

sub build_xml_tree {
  my ( $self, $reader ) = @_;
  my @ns_map;
  my %ns;
  my $tree =
    XML::CompactTree::XS::readSubtreeToPerl( $reader, XCT_DOCUMENT_ROOT, \%ns );
  $ns_map[ $ns{$_} ] = $_ for keys %ns;
  my @nodes = ($tree);

}

__PACKAGE__->meta->make_immutable;
1;
