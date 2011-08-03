package PerlFu::XML::Node;
use Moose;
use namespace::autoclean;
use XML::Toolkit;

has 'author_collection' => (
     isa         => 'ArrayRef[PerlFu::XML::Author]',
     is          => 'ro',     init_arg    => 'authors',
     traits      => [qw(XML Array)],
     lazy        => 1,
     auto_deref  => 1,
     default     => sub { [] },
     handles    => { add_author => ['push'] },     description => {
        LocalName => "author",
        Prefix => "",
        node_type => "child",
        Name => "author",
        NamespaceURI => "",
        sort_order => 0,
     },
);
has 'created' => (
     isa         => 'Str',
     is          => 'ro',   
     traits      => [ 'XML'],
     description => {
        LocalName => "created",
        Prefix => "",
        node_type => "attribute",
        Name => "created",
        NamespaceURI => "",
        sort_order => 1,
     },
);
has 'data_collection' => (
     isa         => 'ArrayRef[PerlFu::XML::Data]',
     is          => 'ro',     init_arg    => 'datas',
     traits      => [qw(XML Array)],
     lazy        => 1,
     auto_deref  => 1,
     default     => sub { [] },
     handles    => { add_data => ['push'] },     description => {
        LocalName => "data",
        Prefix => "",
        node_type => "child",
        Name => "data",
        NamespaceURI => "",
        sort_order => 2,
     },
);
has 'id' => (
     isa         => 'Str',
     is          => 'ro',   
     traits      => [ 'XML'],
     description => {
        LocalName => "id",
        Prefix => "",
        node_type => "attribute",
        Name => "id",
        NamespaceURI => "",
        sort_order => 3,
     },
);
has 'title' => (
     isa         => 'Str',
     is          => 'ro',   
     traits      => [ 'XML'],
     description => {
        LocalName => "title",
        Prefix => "",
        node_type => "attribute",
        Name => "title",
        NamespaceURI => "",
        sort_order => 4,
     },
);
has 'type_collection' => (
     isa         => 'ArrayRef[PerlFu::XML::Type]',
     is          => 'ro',     init_arg    => 'types',
     traits      => [qw(XML Array)],
     lazy        => 1,
     auto_deref  => 1,
     default     => sub { [] },
     handles    => { add_type => ['push'] },     description => {
        LocalName => "type",
        Prefix => "",
        node_type => "child",
        Name => "type",
        NamespaceURI => "",
        sort_order => 5,
     },
);
has 'updated' => (
     isa         => 'Str',
     is          => 'ro',   
     traits      => [ 'XML'],
     description => {
        LocalName => "updated",
        Prefix => "",
        node_type => "attribute",
        Name => "updated",
        NamespaceURI => "",
        sort_order => 6,
     },
);
1;

__END__
