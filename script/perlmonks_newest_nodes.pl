use strict;
use warnings;
use 5.12.0;
use Data::Dumper;
{
  package Herp;
  use Moose;
  use namespace::autoclean;
   
  with 'PerlFu::XML::Perlmonks::NewestNodes';


  1;
}

my $thing = Herp->new;
say "nodes:";
say Dumper $thing->nodes;
