package PerlFu::XML::Parse;

use Moose;
use namespace::autoclean;
use XML::CompactTree::XS;


=head1 build_xml_nodes

Takes an L<XML::LibXML::Reader> object, parses XML using L<XML::CompactTree::XS>

Returns an arrayref of hashrefs.

=cut 

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

__PACKAGE__->meta->make_immutable;
1;
