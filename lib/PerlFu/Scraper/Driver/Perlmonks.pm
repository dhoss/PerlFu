package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;
use WWW::Mechanize;
use XML::Feed;
use Path::Class;

sub scrape_action {
  my ( $self, $uri, $opts ) = @_;
  my $rss;
  my @entries;
  if ( defined $opts->{directory} ) {
    warn "Dir: " . $uri ;
    my $dir = dir $uri;
    my $handle = $dir->open;
    while ( my $file = $handle->read ) {
      $file = $dir->file($file);
      print "File name: $file\n";
      print "File contents: " . $file->slurp . "\n";
    }
  } else {
    $rss = XML::Feed->parse($uri)
      or die XML::Feed->errstr;
    @entries = $rss->entries;
    return \@entries;
  }

}
1;
