#!/usr/bin/env perl

use strict;
use warnings;

use ElasticSearch;
use lib '../../up.perlfu.org/lib';
use WWW::UsePerl::Server::Schema;
my $schema = WWW::UsePerl::Server::Schema->connect('dbi:Pg:dbname=useperl', 'useperl', 'us3p3rl!');
my $user_rs    = $schema->resultset('User');

my $es = ElasticSearch->new(trace_calls  => 'log_file');

for my $user ( $user_rs->all ) {
  print "Adding " . $user->nickname . " to the index\n";
  $es->index(
    index => 'perlfu',
    type  => 'user',
    data  => {
      name   => $user->nickname,
      userid => $user->uid
    }
  );

  print "Adding user data...\n";

  print "Journals...\n";
  for my $journal ( $user->journals->all ) {
    $es->index(
      index => 'perlfu',
      type  => 'journal',
      data  => {
        description => $journal->description,
        article     => $journal->article,
        introtext   => $journal->introtext,
        journalid   => $user->id
      }
    );
  }

  print "Stories...\n";
  for my $story ( $schema->resultset('Story')->all ) {
    $es->index(
      index => 'perlfu',
      type  => 'story',
      data  => {
        storyid   => $story->stoid,
        title     => $story->title,
        introtext => $story->introtext,
        bodytext  => $story->bodytext
      }
    );
  }

  print "Comments...\n";
  for my $comment ( $schema->resultset('Comment')->all ) {
    $es->index(
      index => 'perlfu',
      type  => 'comment',
      data  => {
        commentid => $comment->cid,
        subject   => $comment->subject,
        comment   => $comment->comment,
      }
    );
  }
}
