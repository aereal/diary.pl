package t::InternDiary::Database;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;

use InternDiary::Database;

my $DB = 'InternDiary::Database';

subtest dbh => sub {
    ok $DB->dbh;
};

done_testing;
