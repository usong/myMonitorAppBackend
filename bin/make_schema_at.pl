#!/usr/bin/perl

use warnings;
use strict;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Util::Basic;
use 5.010;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;


my $path = Util::Basic->new()->pdb;
make_schema_at(
      'Util::Schema',
      { debug => 1,
        dump_directory => "$Bin/../lib",
      },
      [ "dbi:SQLite:dbname=$path", '' , '' ],
);

