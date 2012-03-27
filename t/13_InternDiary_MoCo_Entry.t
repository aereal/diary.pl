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
use InternDiary::MoCo::User;

my $Entry = 'InternDiary::MoCo::Entry';
my $User = 'InternDiary::MoCo::User';

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

subtest created_at => sub {
    my $author = $User->create(name => 'Entry Author Dayo');

    subtest inflation => sub {
        subtest 'created_at is 0000-00-00 00:00:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '0000-00-00 00:00:00');
            is $entry->created_at, undef;
        };

        subtest 'created_at is 1991-06-15 03:25:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '1991-06-15 03:25:00');
            isa_ok $entry->created_at, 'DateTime';
            is $entry->created_at->epoch, DateTime->new(year => 1991, month => 6, day => 15, hour => 3, minute => 25)->epoch;
        };

        subtest 'created_at is 1992-10-10 06:30:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '1992-10-10 06:30:00');
            isa_ok $entry->created_at, 'DateTime';
            is $entry->created_at->epoch, DateTime->new(year => 1992, month => 10, day => 10, hour => 6, minute => 30)->epoch;
        };
    };
};

subtest updated_at => sub {
    my $author = $User->create(name => 'Entry Author Dayo (updated)');

    subtest inflation => sub {
        subtest 'is 0000-00-00 00:00:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '0000-00-00 00:00:00');
            is $entry->updated_at, undef;
        };

        subtest 'is 1991-06-15 03:25:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '1991-06-15 03:25:00');
            isa_ok $entry->updated_at, 'DateTime';
            is $entry->updated_at->epoch, DateTime->new(year => 1991, month => 6, day => 15, hour => 3, minute => 25)->epoch;
        };

        subtest 'is 1992-10-10 06:30:00' => sub {
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '1992-10-10 06:30:00');
            isa_ok $entry->updated_at, 'DateTime';
            is $entry->updated_at->epoch, DateTime->new(year => 1992, month => 10, day => 10, hour => 6, minute => 30)->epoch;
        };
    };
};

done_testing;
