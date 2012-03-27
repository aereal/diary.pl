package t::InternDiary::Database;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;

use InternDiary::Database;
use DBIx::RewriteDSN -rules => q/
    dbi:mysql:dbname=intern_diary_aereal dbi:mysql:dbname=intern_diary_aereal_test
/;

my $DB = 'InternDiary::Database';

subtest dbh => sub {
    ok $DB->dbh;
};

done_testing;
