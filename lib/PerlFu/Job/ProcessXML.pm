package PerlFu::Job::ProcessXML;

use Moose;
use namespace::autoclean;
extends 'PerlFu::Job';

sub run { 
 print "I'm processing XML\n";
}

__PACKAGE__->meta->make_immutable;

1;
