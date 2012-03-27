package t::InternDiary::MoCo::User;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;
use DateTime;

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

subtest created_at => sub {
    subtest inflation => sub {
        subtest 'created_at is 0000-00-00 00:00:00' => sub {
            my $user = InternDiary::MoCo::User->create(name => 'unknown birthday-chan', created_at => '0000-00-00 00:00:00');
            is $user->created_at, undef;
        };

        subtest 'created_at is 1992-05-05 00:00:00' => sub {
            my $user = InternDiary::MoCo::User->create(name => 'yuno', created_at => '1992-05-05 00:00:00');
            isa_ok $user->created_at, 'DateTime';
            is $user->created_at->epoch, DateTime->new(year => 1992, month => 05, day => 05)->epoch;
        };
    };
};

done_testing;
