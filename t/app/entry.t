package t::app::Entry;
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Name::FromLine;
use HTTP::Status;
use Ridge::Test 'InternDiary';

use InternDiary::Database;
use InternDiary::MoCo::Entry;

my $Entry = 'InternDiary::MoCo::Entry';

sub reflesh_table {
    InternDiary::Database->execute('TRUNCATE TABLE ' . $_->table) for (($Entry));
}

subtest invalid_route => sub {
    is get('/entry')->code, RC_NOT_FOUND;
};

subtest existent_entry => sub {
    reflesh_table;

    my $entry = $Entry->create;

    is get('/entry?id=' . $entry->id)->code, RC_OK;
};

subtest missing_entry => sub {
    reflesh_table;

    is get('/entry?id=' . 0)->code, RC_NOT_FOUND;
};

1;
