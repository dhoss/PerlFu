#!/usr/bin/env perl
use strict;
use warnings;
use PerlFu::Web;

my $app = PerlFu::Web->psgi_app(@_);

