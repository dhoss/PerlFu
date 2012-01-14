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
  is => 'ro',
  lazy => 1,
  default => 1
);

has next_id => (
  is => 'ro',
  lazy => 1,
  builder => '_build_next_id',
);

has 'ticker_url' => (
  is => 'ro',
  lazy => 1,
  required => 1,
  default => "http://perlmonks.org/?node_id=693598"
);

has 'queue' => (
  is => 'ro',
  isa => 'Net::Kestrel',
  required => 1,
  builder => '_build_queue',
  handles => qr/^.*/,
);

has 'ua' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub {
    return LWP::UserAgent->new
  }
);

has 'document' => (
  is => 'ro',
  lazy => 1,
  builder => '_build_docuent',
);

sub _build_queue {
  Net::Kestrel->new;
}

sub _build_next_id {
  my $self = shift;
  my $document = $self->document;
}

sub _build_document {
  my $self = shift;

}

sub execute {
  my ( $self ) = @_;
  my $ua = $self->ua;
  my $res = $ua->request(GET $self->ticker_url . ";id=1");
  say Dumper $res->content;
  
}

__PACKAGE__->meta->make_immutable;
1;
