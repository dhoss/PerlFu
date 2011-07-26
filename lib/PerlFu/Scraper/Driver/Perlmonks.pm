package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;
use WWW::Mechanize;
use XML::Feed;
use XML::Twig;
use File::Find::Rule;
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

sub scrape_action {
  my ( $self, $uri, $opts ) = @_;
  my $rss;
  my @entries;
  if ( defined $opts->{directory} ) {
    print "Dir: " . $uri . "\n";
    print "Collecting files...\n";
    my @files = File::Find::Rule->file()->name("*.xml")->in($uri);
    for my $file ( @files ) {
      my $t = $self->twig;
      print "File name: $file\n";
      print "Parsing...\n";
      $t->parsefile($file) 
        or die "Can't parse $file: $!";
      print "Indexing...\n";
      #$self->es->index(
      #  index => 'perlfu',
      #  type  => 'perlmonks_node',
      #  data  => {
      #  }
      #);
    }
  } else {
    $rss = XML::Feed->parse($uri)
      or die XML::Feed->errstr;
    @entries = $rss->entries;
    return \@entries;
  }

}
1;
