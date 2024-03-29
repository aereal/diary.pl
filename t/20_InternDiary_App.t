package t::InternDiary::App;
use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;
use Test::Fatal;
use List::MoreUtils ':all';
use Data::Dumper;
use Test::Mock::Guard qw/mock_guard/;
use Test::Fatal qw/exception lives_ok dies_ok/;

use InternDiary::Database;
use InternDiary::MoCo::Entry;
use InternDiary::MoCo::User;
use InternDiary::App;

my $Entry = 'InternDiary::MoCo::Entry';
my $User = 'InternDiary::MoCo::User';
my $App = 'InternDiary::App';

sub reflesh_table {
    InternDiary::Database->execute("TRUNCATE TABLE " . $_->table) for (($User, $Entry));
}

subtest initialize => sub {
    new_ok $App;
};

subtest current_user => sub {
    my $app = $App->new;
    can_ok $app, 'current_user';

    subtest 'no users registered' => sub {
        reflesh_table;

        is $app->current_user, undef;
    };

    subtest 'any users registered' => sub {
        reflesh_table;

        my $last_user = $User->create(name => 'aereal');
        isa_ok $app->current_user, $User;
        is $app->current_user->name, $last_user->name;
    };
};

subtest list_entries => sub {
    reflesh_table;

    my $app = $App->new;
    can_ok $app, 'list_entries';

    my $author = $User->create(name => 'aereal');

    subtest 'when no entries found' => sub {
        ok $author->entries->is_empty;
        is_deeply $app->list_entries, [];
    };

    subtest 'some entries found' => sub {
        $author->create_entry({title => "Hello! #$_", body => "Written diary for $_ time(s)"})
            for (1 .. 3);
        ok not $author->entries->is_empty;
        is_deeply $app->list_entries, $author->entries->to_a;
    };
};

subtest create_entry => sub {
    reflesh_table;

    my $user = $User->create(name => 'aereal');

    my $app = $App->new;
    can_ok $app, 'create_entry';

    my $title = 'This is my title';
    my $body = "Hello World\nThese lines are body";
    my $complexed = join "\n\n", ($title, $body);

    $app->create_entry($complexed);

    my $last_my_entry = $Entry->search(where => {user_id => $user->id}, order => 'created_at DESC', limit => 1)->first;
    isa_ok $last_my_entry, $Entry;
    is $last_my_entry->title, $title;
    is $last_my_entry->body, $body;
};

subtest update_entry => sub {
    reflesh_table;

    my $user = $User->create(name => 'aereal');
    my $app = $App->new;

    can_ok $app, 'update_entry';

    my $old_entry = $Entry->create(title => 'Old My Entry', body => "Lorem Ipsum.\nLorem Ipsum.\nLorem Ipsum.");

    my $new_title = 'New My Entry';
    my $new_body = "Hello World";
    my $complexed = join "\n\n", ($new_title, $new_body);
    $app->update_entry($old_entry->id => $complexed);

    my $new_entry = $Entry->find(id => $old_entry->id);
    is $new_entry->title, $new_title;
    is $new_entry->body, $new_body;
};

subtest destroy_entry => sub {
    reflesh_table;

    my $app = $App->new;
    my $author = $User->create(name => 'aereal');

    can_ok $app, 'destroy_entry';

    subtest 'when given missing entry_id' => sub {
        my $missing_entry_id = 123456;
        like exception { $app->destroy_entry($missing_entry_id) }, qr/Entry not found/;
    };

    subtest 'entry is found' => sub {
        reflesh_table;
        my $old_entry = $Entry->create(title => 'Hi', body => 'Sushi me', user_id => $author->id);
        my $before_entries_count = $author->entries->size;
        ok not $Entry->search(where => {title => $old_entry->title, body => $old_entry->body, user_id => $author->id})->is_empty;

        $app->destroy_entry($old_entry->id);

        is $author->entries->size, $before_entries_count - 1;
        ok $Entry->search(where => {title => $old_entry->title, body => $old_entry->body, user_id => $author->id})->is_empty;
    };
};

subtest login => sub {
    reflesh_table;

    my $app = $App->new;
    can_ok $app, 'login';

    subtest 'no args given' => sub {
        like exception { $app->login }, qr/No username given/;
    };

    subtest 'username given' => sub {
        subtest 'it is not registered yet' => sub {
            reflesh_table;

            my $missing_name = 'missreal';
            like exception { $app->login($missing_name) }, qr/Given name is not found/;
        };

        subtest 'it is already taken' => sub {
            reflesh_table;

            my $name = 'aereal';
            $User->create(name => $name);

            my $result = $app->login($name);
            isa_ok $result, $User;
            is $result->name, $name;
        };
    };
};

subtest register => sub {
    reflesh_table;

    my $app = $App->new;
    can_ok $app, 'register';
    ok $User->search->is_empty;

    subtest 'no args given' => sub {
        like exception { $app->register }, qr/No username given/;
    };

    subtest 'username given' => sub {
        subtest 'it is not registered yet' => sub {
            reflesh_table;

            my $new_username = 'aereal';
            $app->register($new_username);

            ok not $User->search->is_empty;

            my $last_user = $User->search(order => 'created_at DESC', limit => 1)->first;
            isa_ok $last_user, $User;
            is $last_user->name, $new_username;
        };

        subtest 'it is already registered' => sub {
            reflesh_table;

            my $earlier_user = $User->create(name => 'earliereal');
            my $duplicated_name = $earlier_user->name;

            like exception { $app->register($duplicated_name) }, qr/Given name is already taken/;
        };
    };
};

done_testing;
