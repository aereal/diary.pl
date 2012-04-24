package InternDiary;
use strict;
use warnings;
use parent qw/Ridge/;
use URI;
use URI::QueryParam;
use InternDiary::MoCo::User;

__PACKAGE__->configure;

sub current_user {
    my ($self) = @_;
    InternDiary::MoCo::User->search->first;
}

sub entries_path { '/entry' }

sub new_entry_path { '/entry.new_' }

sub entry_path {
    shift;
    my $u = URI->new('/entry');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

sub edit_entry_path {
    shift;
    my $u = URI->new('/entry.edit');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

1;
