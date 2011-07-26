package PerlFu::Scraper;

use Moose;
use namespace::autoclean;
use File::Find::Rule;
with 'MooseX::Workers';

has 'driver' => (
  is       => 'rw',
  lazy     => 1,
  required => 1,
  default  => sub { die "driver class name required" }
);

has 'rule' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub {
    File::Find::Rule->new->file();
  }
);


with 'PerlFu::Scraper::Driver';

sub scrape_it {
  my ( $self, $uri, $opts ) = @_;
  $self->setup;
  $self->scrape_action( $uri, $opts );
}

sub run {
  my ($self, $uri, $opts) = @_;
  my $rule = $self->rule->name("*.xml");
  my @files = $rule->in($uri);

  $self->max_workers(100);
  for my $file (@files) {
    $self->enqueue( $self->scrape_it($file, $opts) );
    warn "WORKERS: " . $self->num_workers;
  }
  POE::Kernel->run();
}

sub worker_stdout { shift; warn join ' ', @_; }
sub worker_stderr { shift; warn join ' ', @_; }

sub worker_manager_start { warn 'started worker manager' }
sub worker_manager_stop  { warn 'stopped worker manager' }

sub max_workers_reached { warn 'maximum worker count reached' }
sub worker_error        { shift; warn join ' ', @_; }
sub worker_done         { shift; warn join ' ', @_; }
sub worker_started      { shift; warn join ' ', @_; }
sub sig_child           { shift; warn join ' ', @_; }

sub sig_TERM {
  shift;
  warn 'Handled TERM';
}


__PACKAGE__->meta->make_immutable;
1;
