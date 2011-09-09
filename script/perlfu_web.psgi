#!/usr/bin/env perl
use strict;
use warnings;
use PerlFu::Web;

builder {
  enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 
          "Plack::Middleware::ReverseProxy";
  my $app =  PerlFu::Web->psgi_app;
};

