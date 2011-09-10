package PerlFu::Web::Messages;
use Moose::Role;
use Message::Stack;
use Data::Dumper;

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

sub message {
  my ( $self, $message, $level, $msgid ) = @_;

  $self->add({ 
    msgid     => $msgid || "",
    level     => $level || "notify",
    text      => $message
  }) if $message;
  $self->stash( messages => $self->messages )
    unless $level eq 'error';
  return $self->messages

}

1;
