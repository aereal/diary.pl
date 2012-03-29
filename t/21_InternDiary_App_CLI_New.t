package t::InternDiary::App::CLI::Command::New;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use InternDiary::App::CLI::Command::New;

my $New = 'InternDiary::App::CLI::Command::New';

subtest initialize => sub {
    new_ok $New;
};

done_testing;
