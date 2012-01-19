package PerlFu::Job::ProcessXML;

use Moose::Role;
use namespace::autoclean;
use XML::CompactTree::XS;
use Data::Dumper;

requires qw( run document build_hash source );

sub build_xml_nodes {
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
  return \@nodes;
}

before run => sub { 
  my $self = shift;
};



1;
