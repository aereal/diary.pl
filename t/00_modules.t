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
        use_ok 'InternDiary::App::CLI::New';
        use_ok 'InternDiary::App::CLI::List';
        use_ok 'InternDiary::App::CLI::Edit';
    };
}

done_testing;
