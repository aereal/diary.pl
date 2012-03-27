package t::InternDiary::MoCo::User;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;

use InternDiary::Database;
use InternDiary::MoCo::User;

my $User = 'InternDiary::MoCo::User';

subtest inheritance => sub {
    ok any { $_ eq 'InternDiary::MoCo' } @InternDiary::MoCo::User::ISA;
};

subtest table => sub {
    is $User->table, 'users';
};

subtest schema => sub {
    my $schema = $User->schema;
    is_deeply [sort @{$schema->primary_keys}], [sort qw/id/];
    is_deeply [sort @{$schema->unique_keys}], [sort qw/id name/];
    is_deeply [sort @{$schema->columns}], [sort qw/id name created_at/];
};

done_testing;
