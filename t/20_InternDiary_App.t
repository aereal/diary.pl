package t::InternDiary::App;
use strict;
use warnings;
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
    };
};

done_testing;
