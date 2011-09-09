package PerlFu::Cmd;

use Moose;
use namespace::autoclean;
extends qw(MooseX::App::Cmd);
# ABSTRACT: base class for perlfu's CLI operations
__PACKAGE__->meta->make_immutable;
1;
