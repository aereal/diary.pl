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

subtest schema => sub {
    my $schema = $Entry->schema;
    is_deeply [sort @{$schema->primary_keys}], [sort qw/id/];
    is_deeply [sort @{$schema->columns}], [sort qw/id title body created_at updated_at user_id/];
};

done_testing;
