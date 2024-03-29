package t::InternDiary::MoCo::User;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;
use DateTime;
use Test::Mock::Guard qw/mock_guard/;

use InternDiary::Database;
use InternDiary::MoCo::User;
use InternDiary::MoCo::Entry;

my $User = 'InternDiary::MoCo::User';
my $Entry = 'InternDiary::MoCo::Entry';

sub reflesh_table {
    InternDiary::Database->execute("TRUNCATE TABLE " . $_->table) for (($User, $Entry));
}

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
    reflesh_table;

    subtest inflation => sub {
        subtest 'created_at is 0000-00-00 00:00:00' => sub {
            reflesh_table;
            my $user = InternDiary::MoCo::User->create(name => 'unknown birthday-chan', created_at => '0000-00-00 00:00:00');
            is $user->created_at, undef;
        };

        subtest 'created_at is 1992-05-05 00:00:00' => sub {
            reflesh_table;
            my $user = InternDiary::MoCo::User->create(name => 'yuno', created_at => '1992-05-05 00:00:00');
            isa_ok $user->created_at, 'DateTime';
            is $user->created_at->epoch, DateTime->new(year => 1992, month => 05, day => 05)->epoch;
        };

        subtest 'created_at is 1992-10-10 06:30:00' => sub {
            reflesh_table;
            my $user = InternDiary::MoCo::User->create(name => 'miyako', created_at => '1992-10-10 00:00:00');
            isa_ok $user->created_at, 'DateTime';
            is $user->created_at->epoch, DateTime->new(year => 1992, month => 10, day => 10)->epoch;
        };
    };

    subtest set_current_time => sub {
        subtest 'when created_at is not given' => sub {
            mock_guard 'DateTime', {
                now => sub { DateTime->new(year => 2012, month => 4, day => 1, time_zone => 'UTC', formatter => 'DateTime::Format::MySQL') }};
            reflesh_table;
            my $new_user = $User->create(name => 'hogereal');
            isa_ok $new_user->created_at, 'DateTime';
            is $new_user->created_at->epoch, DateTime->now->epoch;
        };
    };
};

subtest create_entry => sub {
    reflesh_table;
    my $author = $User->create(name => 'aereal');

    can_ok $author, 'create_entry';

    my $before_entries_count = $Entry->count(user_id => $author->id);
    my $entry_args = {title => 'My First Diary', body => 'Hello World'};
    $author->create_entry($entry_args);

    my $last_my_entry = $Entry->search(where => {user_id => $author->id}, order => 'created_at DESC', limit => 1)->first;

    isa_ok $last_my_entry, $Entry;
    is $last_my_entry->title, $entry_args->{title};
    is $last_my_entry->body, $entry_args->{body};
    is $Entry->count(user_id => $author->id), $before_entries_count + 1;
};

subtest entries => sub {
    reflesh_table;
    my $author = $User->create(name => 'aereal');

    can_ok $author, 'entries';
    isa_ok $author->entries, 'DBIx::MoCo::List';
    ok $author->entries->is_empty;

    my $first_entry_args = {title => 'Hello World', body => 'shut the fuck up and write some diary'};
    $author->create_entry($first_entry_args);

    ok not $author->entries->is_deeply;
    ok defined $author->entries->find(sub { $_->title eq $first_entry_args->{title} && $_->body eq $first_entry_args->{'body'} });
};

done_testing;
