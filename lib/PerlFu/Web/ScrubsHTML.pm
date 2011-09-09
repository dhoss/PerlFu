package PerlFu::Web::ScrubsHTML;
use Moose::Role;
use HTML::Scrubber;

has 'scrubber' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub { 
    HTML::Scrubber->new(%{shift->scrubber_opts})
  },
);

has 'scrubber_opts' => (
  is => 'rw',
  required => 1,
  lazy => 1,
  default => sub {
    {
      allow => [ qw[ p b i u hr br ]
    }
  },
);

sub scrub {
  my ($self, $dirty) = @_;
  return $self->scrubber->scrub($dirty);
}

1;
