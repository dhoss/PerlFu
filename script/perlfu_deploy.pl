#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PerlFu::Schema;
my $schema = PerlFu::Schema->connect('dbi:Pg:dbname=perlfu;port=5434', "postgres", "");;

$schema->deploy({ add_drop_table => 1 });

