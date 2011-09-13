package PerlFu::Web::Messages;
use Moose::Role;
use Message::Stack;
use Data::Dumper;
use Params::Validate;

has '_stack' => (
  is => 'rw',
  lazy => 1,
  default => sub { Message::Stack->new },
  required => 1,
  handles => {
    messages => 'messages',
    add      => 'add',
  }
);

has 'levels' => (
  is => 'rw',
  isa => 'HashRef',
  lazy => 1,
  required => 1,
  default => sub {
    {
      notify => 'messages',
      fatal  => 'errors',
      error  => 'errors',
    },
  },
);

sub message {
  my @p = validate_pos( @_, 1, 1, 0, { default => 'notify' },  0);
  my ( $self, $message, $level, $msgid ) = @p;
  $self->add({ 
    msgid     => $msgid || "",
    level     => $level,
    text      => $message
  });
  warn "MESSAGES" . Dumper $self->messages; 
  $self->stash( $self->levels->{$level}  => $self->messages );
  #return $self->messages

}

1;
