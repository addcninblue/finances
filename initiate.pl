#!/usr/bin/perl
use v5.24;
use strict;
use warnings;

use DBI;

my $dbfile = "finances.db";

my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

my $sql = <<'END_SQL';
CREATE TABLE spendings (
  id       INTEGER PRIMARY KEY,
  desc     VARCHAR(1000),
  amount   INTEGER,
  spendDate DATE,
  type     VARCHAR(1000)
)
END_SQL
$dbh->do($sql);

$dbh->disconnect;
