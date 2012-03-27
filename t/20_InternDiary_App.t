package t::InternDiary::App;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;
use Test::Mock::Guard qw/mock_guard/;

use InternDiary::Database;
use InternDiary::MoCo::Entry;
use InternDiary::MoCo::User;
use InternDiary::App;

my $Entry = 'InternDiary::MoCo::Entry';
my $User = 'InternDiary::MoCo::User';
my $App = 'InternDiary::App';

subtest initialize => sub {
    new_ok $App;
};

done_testing;
