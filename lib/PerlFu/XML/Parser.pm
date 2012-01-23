package PerlFu::XML::Parser;

use 5.12.0;
use Moose;
use namespace::autoclean;
use XML::CompactTree::XS;
use XML::LibXML::Reader;
use Data::Dumper;

=head1 build_xml_nodes

Takes an L<XML::LibXML::Reader> object, parses XML using L<XML::CompactTree::XS>

Returns an arrayref of hashrefs.

=cut 

sub build_xml_nodes {
  my ( $self, $contents ) = @_;
  say "Building nodes";
  my $reader   = XML::LibXML::Reader->new( string => $contents )
    || die "can't read file $!";
  my @ns_map;
  my %ns;
  say "Building tree";
  my $tree =
    XML::CompactTree::XS::readSubtreeToPerl( 
      $reader,
      XCT_DOCUMENT_ROOT,
      \%ns 
  );
  say "Mapping keys";
  $ns_map[ $ns{$_} ] = $_ for keys %ns;
  my @nodes = ($tree);
  return \@nodes;
}


__PACKAGE__->meta->make_immutable;
1;
