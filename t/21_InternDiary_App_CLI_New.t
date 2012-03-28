package t::InternDiary::App::CLI::New;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use InternDiary::App::CLI::New;

my $New = 'InternDiary::App::CLI::New';

subtest initialize => sub {
    new_ok $New;
};

done_testing;
