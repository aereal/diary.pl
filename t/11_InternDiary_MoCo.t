package t::InternDiary::MoCo;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;

use InternDiary::Moco;

subtest db_object => sub {
    is 'InternDiary::MoCo'->db_object, 'InternDiary::Database';
};

done_testing;
