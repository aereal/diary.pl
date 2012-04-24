package t::app::Index;
use strict;
use warnings;
use Test::More qw(no_plan);
use HTTP::Status;
use Ridge::Test 'InternDiary';

is get('/index')->code, RC_OK;

1;
