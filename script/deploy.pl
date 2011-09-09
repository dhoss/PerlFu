#!/usr/bin/env perl

use strict;
use warnings;

use feature ":5.10";

use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use FindBin;
use lib "$FindBin::Bin/../lib";
use PerlFu::Schema;
use Config::JFDI;

my $config       = Config::JFDI->new( name => 'PerlFu::Web' );
my $config_hash  = $config->get;
my $connect_info = $config_hash->{"Model::Database"}{"connect_info"};
my $schema       = PerlFu::Schema->connect($connect_info);

my $dh = DH->new(
  {
    schema           => $schema,
    script_directory => "$FindBin::Bin/../sql",
    databases        => 'PostgreSQL',
    force_overwrite => 1 
  }
);

sub install {
  $dh->prepare_install;
  $dh->install;
}

sub upgrade {
  die "Please update the version in Schema.pm"
    if (
    $dh->version_storage->version_rs->search(
      { version => $dh->schema_version }
    )->count
    );

  die "We only support positive integers for versions around these parts."
    unless $dh->schema_version =~ /^\d+$/;

  $dh->prepare_deploy;
  $dh->prepare_upgrade;
  $dh->upgrade;
}

sub current_version {
  say $dh->database_version;
}

sub help {
  say <<'OUT';
                                         usage:
                                           install
                                             upgrade
                                               current-version
OUT
}

help unless $ARGV[0];

given ( $ARGV[0] ) {
  when ('install')         { install() }
  when ('upgrade')         { upgrade() }
  when ('current-version') { current_version() }
}
