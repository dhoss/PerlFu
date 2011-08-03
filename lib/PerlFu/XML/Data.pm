package PerlFu::XML::Data;
use Moose;
use namespace::autoclean;
use XML::Toolkit;

has 'field_collection' => (
     isa         => 'ArrayRef[PerlFu::XML::Field]',
     is          => 'ro',     init_arg    => 'fields',
     traits      => [qw(XML Array)],
     lazy        => 1,
     auto_deref  => 1,
     default     => sub { [] },
     handles    => { add_field => ['push'] },     description => {
        LocalName => "field",
        Prefix => "",
        node_type => "child",
        Name => "field",
        NamespaceURI => "",
        sort_order => 0,
     },
);
1;

__END__
