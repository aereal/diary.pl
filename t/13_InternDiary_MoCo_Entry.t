package t::InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent qw/Test::Class/;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;
use Test::Mock::Guard qw/mock_guard/;
use Test::Fatal qw/exception lives_ok/;

use InternDiary::Database;
use InternDiary::MoCo::Entry;
use InternDiary::MoCo::User;

my $Entry = 'InternDiary::MoCo::Entry';
my $User = 'InternDiary::MoCo::User';

sub reflesh_table {
    InternDiary::Database->execute("TRUNCATE TABLE " . $_->table) for (($Entry, $User));
}

subtest extract_title => sub {
    my $title = 'Hello My Title';
    my $body = 'Hello My Body';
    my $complexed = join "\n\n", ($title, $body);
    my @extracted = $Entry->extract_title($complexed);
    is $extracted[0], $title;
    is $extracted[1], $body;
};

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
    reflesh_table;
    my $author = $User->create(name => 'Entry Author Dayo');

    subtest inflation => sub {
        subtest 'created_at is 0000-00-00 00:00:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '0000-00-00 00:00:00');
            is $entry->created_at, undef;
        };

        subtest 'created_at is 1991-06-15 03:25:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '1991-06-15 03:25:00');
            isa_ok $entry->created_at, 'DateTime';
            is $entry->created_at->epoch, DateTime->new(year => 1991, month => 6, day => 15, hour => 3, minute => 25)->epoch;
        };

        subtest 'created_at is 1992-10-10 06:30:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                created_at => '1992-10-10 06:30:00');
            isa_ok $entry->created_at, 'DateTime';
            is $entry->created_at->epoch, DateTime->new(year => 1992, month => 10, day => 10, hour => 6, minute => 30)->epoch;
        };
    };

    subtest set_current_time => sub {
        subtest 'when created_at is not given' => sub {
            mock_guard 'DateTime', {
                now => sub { DateTime->new(year => 2012, month => 4, day => 1, time_zone => 'UTC', formatter => 'DateTime::Format::MySQL') }};
            reflesh_table;
            my $empty_ts_entry = $Entry->create(
                title => 'created_at is',
                body => 'empty dayo ~',
                user_id => $author->id);
            isa_ok $empty_ts_entry->created_at, 'DateTime';
            is $empty_ts_entry->created_at->epoch, DateTime->now->epoch;
        };
    };
};

subtest updated_at => sub {
    reflesh_table;
    my $author = $User->create(name => 'Entry Author Dayo (updated)');

    subtest inflation => sub {
        subtest 'is 0000-00-00 00:00:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '0000-00-00 00:00:00');
            is $entry->updated_at, undef;
        };

        subtest 'is 1991-06-15 03:25:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '1991-06-15 03:25:00');
            isa_ok $entry->updated_at, 'DateTime';
            is $entry->updated_at->epoch, DateTime->new(year => 1991, month => 6, day => 15, hour => 3, minute => 25)->epoch;
        };

        subtest 'is 1992-10-10 06:30:00' => sub {
            reflesh_table;
            my $entry = $Entry->create(
                title => 'Sketch Switch',
                body => 'Donna Iro ga Ima desu-ka?',
                user_id => $author->id,
                updated_at => '1992-10-10 06:30:00');
            isa_ok $entry->updated_at, 'DateTime';
            is $entry->updated_at->epoch, DateTime->new(year => 1992, month => 10, day => 10, hour => 6, minute => 30)->epoch;
        };
    };

    subtest set_current_time => sub {
        subtest 'when updated_at is not given' => sub {
            mock_guard 'DateTime', {
                now => sub { DateTime->new(year => 2012, month => 4, day => 1, time_zone => 'UTC', formatter => 'DateTime::Format::MySQL') }};
            reflesh_table;
            my $empty_upts_entry = $Entry->create(
                title => 'updated_at is',
                body => 'empty dayo ~',
                user_id => $author->id);
            isa_ok $empty_upts_entry->updated_at, 'DateTime';
            is $empty_upts_entry->updated_at->epoch, DateTime->now->epoch;
        };

        subtest 'when object is updated' => sub {
            reflesh_table;
            my $old_ts = DateTime->new(year => 2011, month => 4, day => 1, time_zone => 'UTC', formatter => 'DateTime::Format::MySQL');
            my $updated_entry = $Entry->create(
                title => 'updated_at is',
                body => 'empty dayo ~',
                created_at => $old_ts,
                updated_at => $old_ts,
                user_id => $author->id);
            mock_guard 'DateTime', {
                now => sub { DateTime->new(year => 2012, month => 4, day => 1, time_zone => 'UTC', formatter => 'DateTime::Format::MySQL') }};
            $updated_entry->body($updated_entry->body . 'dayo ~');
            isa_ok $updated_entry->updated_at, 'DateTime';
            is $updated_entry->updated_at->epoch, DateTime->now->epoch;
        };
    };
};

subtest author => sub {
    reflesh_table;

    my $author = $User->create(name => 'yuno');
    my $entry = $Entry->create(title => 'Hajimete no Nikki', body => 'Ma, Taitei nanndemo shitte-masu kedo!', user_id => $author->id);

    can_ok $entry, 'author';
    isa_ok $entry->author, $User;
    for (@{$User->columns}) {
        is $author->$_, $entry->author->$_, $_;
    }
};

subtest search_with_duration => sub {
    reflesh_table;

    can_ok $Entry, 'search_with_duration';

    subtest 'when no entries found' => sub {
        ok $Entry->search_with_duration->is_empty;
    };

    subtest 'some entries found' => sub {
        reflesh_table;
        my $author = $User->create(name => 'aereal');
        $author->create_entry({title => "Hello! #$_", body => "Written diary for $_ time(s)"})
            for (1 .. 3);
        ok not $Entry->search_with_duration->is_empty;

        subtest 'given start of range' => sub {
            subtest 'given invalid date format' => sub {
                like exception { $Entry->search_with_duration('hoge') }, qr/Invalid W3CDTF datetime string/;
            };

            subtest 'given valid date format' => sub {
                lives_ok { $Entry->search_with_duration('2011') };
            };
        };

        subtest 'given end of range' => sub {
            subtest 'given invalid date format' => sub {
                like exception { $Entry->search_with_duration(undef, 'hoge') }, qr/Invalid W3CDTF datetime string/;
            };

            subtest 'given valid date format' => sub {
                lives_ok { $Entry->search_with_duration(undef, '2011') };
            };
        };
    };
};

done_testing;
