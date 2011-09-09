#!/usr/bin/env perl
use strict;
use warnings;
use PerlFu::Web;

PerlFu::Web->setup_engine('PSGI');
my $app = sub { PerlFu::Web->run(@_) };

