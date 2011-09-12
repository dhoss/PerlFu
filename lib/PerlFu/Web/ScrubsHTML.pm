package PerlFu::Web::ScrubsHTML;
use Moose::Role;
use HTML::StripScripts::Parser;

has 'scrubber' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub { 
    HTML::StripScripts::Parser->new(%{shift->scrubber_opts})
  },
);

has 'scrubber_opts' => (
  is => 'rw',
  required => 1,
  lazy => 1,
  default => sub {
    {
      BanAllBut  => [qw(p div span)],
    }
  },
);

sub scrub {
  my ($self, $dirty) = @_;
  my $html = $self->scrubber->filter_html($dirty); 
  warn "HTML $html";
  return $html
}

1;
