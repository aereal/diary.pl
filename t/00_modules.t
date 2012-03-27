use strict;
use warnings;
use Test::More;

BEGIN {
    subtest load_modules => sub {
        use_ok 'InternDiary::Database';
        use_ok 'InternDiary::MoCo';
    };
}

done_testing;
