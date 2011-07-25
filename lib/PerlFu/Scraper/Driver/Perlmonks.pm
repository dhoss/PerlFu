package PerlFu::Scraper::Driver::Perlmonks;

use Moose::Role;
use namespace::autoclean;

use Web::Scraper;

sub scrape_action {
  my $self = shift;
  my $scraper = scraper {
    process "table", "posts[]" => scraper {
      process ".post_body", body  => "TEXT";
      process "tr.post_head > td:first-child > a", title => "TEXT"; 
    };
  };
  
}

1;
