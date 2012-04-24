package t::InternDiary;
use strict;
use warnings;
use Test::More qw/no_plan/;
use Test::Name::FromLine;

use InternDiary;

my $r = 'InternDiary';

subtest entries_path => sub {
    is $r->entries_path, '/entry';
};

subtest new_entry_path => sub {
    is $r->new_entry_path, '/entry.new_';
};

subtest entry_path => sub {
    is $r->entry_path(id => 1), '/entry?id=1';
    is $r->entry_path(id => 10), '/entry?id=10';
    is $r->entry_path(id => 50, page => 1), '/entry?id=50&page=1';
};

subtest edit_entry_path => sub {
    is $r->edit_entry_path(id => 1), '/entry.edit?id=1';
    is $r->edit_entry_path(id => 10), '/entry.edit?id=10';
    is $r->edit_entry_path(id => 50, page => 1), '/entry.edit?id=50&page=1';
};
