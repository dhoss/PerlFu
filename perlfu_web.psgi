#!/usr/bin/env perl
use strict;
use warnings;
use lib "lib";
use PerlFu::Web;

my $app = PerlFu::Web->apply_default_middlewares(
  PerlFu::Web->psgi_app
);
$app;
