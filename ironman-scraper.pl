use strict;
use Web::Scraper;
use URI;
use Data::Dumper;
use IO::All;
my $posts = scraper {
  process "div.entry", "entries[]" => scraper {
    process "a.entry-source-link", author => 'TEXT',
    process "a.entry-link", link => 'TEXT';
    process "a[href].entry-link", url => '@href';
    process ".entry-tag", tags => 'TEXT';
    process ".entry-body", body => 'TEXT';
  };
};

my $res = $posts->scrape( URI->new('http://ironman.enlightenedperl.org/') );
for my $entry ( @{ $posts->{'entries'} } ) {
  print "entry " . Dumper $entry . "\n";
  print "writing " . $entry->{'url'} . " to file\n";
  my $string = $entry->{'url'} . "," . $entry->{'link'} . "," . $entry->{'body'} . "\n";
  $string > io('ironman.txt');
}
