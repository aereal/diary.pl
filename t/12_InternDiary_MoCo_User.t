package t::InternDiary::MoCo::User;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;

use InternDiary::MoCo::User;

my $User = 'InternDiary::MoCo::User';

subtest inheritance => sub {
    ok any { $_ eq 'InternDiary::MoCo' } @InternDiary::MoCo::User::ISA;
};

subtest table => sub {
    is $User->table, 'users';
};

done_testing;
