use strict;
use warnings;
use Test::More;

BEGIN {
    subtest load_modules => sub {
        use_ok 'InternDiary::Database';
        use_ok 'InternDiary::MoCo';
        use_ok 'InternDiary::MoCo::User';
        use_ok 'InternDiary::MoCo::Entry';
        use_ok 'InternDiary::App';
        use_ok 'InternDiary::App::CLI::Base';
        use_ok 'InternDiary::App::CLI::Command::New';
        use_ok 'InternDiary::App::CLI::Command::List';
        use_ok 'InternDiary::App::CLI::Command::Edit';
        use_ok 'InternDiary::App::CLI::Command::Destroy';
        use_ok 'InternDiary::App::CLI::Command::Auth';
    };
}

done_testing;
