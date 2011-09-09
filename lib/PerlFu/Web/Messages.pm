package Perl::Web::Messages;
use Moose::Role;
use Message::Stack;

has 'stack' => (
  is => 'rw',
  lazy => 1,
  default => sub { Message::Stack->new },
  required => 1,
);

sub messages {
  my ( $self, $message, $level, $msgid ) = @_;

  $self->stack->add( 
    msgid     => $msgid || "",
    level     => $level || 'notify',
    text      => $message
  ) if $message;

  return $self->stack->for_level('notify')

}

1;
