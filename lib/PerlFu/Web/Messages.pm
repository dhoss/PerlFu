package PerlFu::Web::Messages;
use Moose::Role;
use Message::Stack;
use Data::Dumper;

has '_stack' => (
  is => 'rw',
  lazy => 1,
  default => sub { Message::Stack->new },
  required => 1,
);

sub messages {
  my ( $self, $message, $level, $msgid ) = @_;

  $self->_stack->add( Message::Stack::Message->new(
      msgid     => $msgid || "",
      level     => $level || "",
      text      => $message
    ) 
  ) if $message;
  return $self->_stack->messages

}

1;
