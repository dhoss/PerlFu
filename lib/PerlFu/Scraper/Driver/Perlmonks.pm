package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;
use WWW::Mechanize;
use XML::Feed;
use XML::Twig;
use File::Find::Rule;
use Data::Dumper;
use Try::Tiny;
# needs to go in a BB container
use ElasticSearch;

has 'es' => (
  is => 'ro',
  required => 1,
  default => sub {
    ElasticSearch->new(
      servers      => 'localhost:9200',
      transport    => 'http',                  # default 'http'
      max_requests => 10_000,                 # default 10_000
      trace_calls  => 'log_file',
      no_refresh   => 0 ,
    );
  }
);

has 'twig' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub {
    XML::Twig->new;
  },
);

has 'rule' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub {
    File::Find::Rule->new->file();
  }
);

sub scrape_action {
  my ( $self, $uri, $opts ) = @_;
  my $rss;
  my @entries;
  if ( defined $opts->{directory} ) {
    print "Dir: " . $uri . "\n";
    print "Collecting files...\n";
    my $rule = $self->rule->name("*.xml");
    my @files = $rule->in($uri);
    for my $file ( @files ) {
      my $t = $self->twig;
      print "File name: $file\n";
      print "Parsing...\n";
      try { $t->safe_parsefile($file) }
      catch { warn "Can't parse $file: $!" };
      my $root = $t->root;
      my $node = $t->first_elt('node');
      my $author;
      my $body;
      try { $author = $t->first_elt('node')->first_child_text('author') }
      catch { warn $_; $author = "unknown perlmonks author" };
      try { $body = $t->first_elt('data')->first_child_text('field') }
      catch { warn $_; $body = "no body" };
      my $data = {
        id => $node->att('id'),
        title => $node->att('title'),
        created => $node->att('created'),
        updated => $node->att('updated'),
        author => {
          id => $t->first_elt('author')->att('id'),
          name => $author,
        },
        body => $body,
      };
      print "Data: " . Dumper $data;
      print "Indexing...\n";
      $self->es->index(
        index => 'perlfu',
        type  => 'perlmonks_node',
        data  => $data,
        create => 1,
      );
    }
  } else {
    $rss = XML::Feed->parse($uri)
      or die XML::Feed->errstr;
    @entries = $rss->entries;
    return \@entries;
  }

}
1;
