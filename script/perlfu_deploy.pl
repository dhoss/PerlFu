#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PerlFu::Schema;
my $schema = PerlFu::Schema->connect('dbi:SQLite:perlfu.db', "", "");;

$schema->deploy({ add_drop_table => 1 });

