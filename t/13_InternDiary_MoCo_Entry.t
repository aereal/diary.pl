package t::InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;

use InternDiary::Database;
use InternDiary::MoCo::Entry;

my $Entry = 'InternDiary::MoCo::Entry';

subtest inheritance => sub {
    ok any { $_ eq 'InternDiary::MoCo' } @InternDiary::MoCo::Entry::ISA;
};

subtest table => sub {
    is $Entry->table, 'entries';
};

done_testing;
