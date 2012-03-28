package InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent 'InternDiary::MoCo';
use InternDiary::MoCo::User;
use DateTime::Format::W3CDTF;

__PACKAGE__->table('entries');

sub search_with_duration {
    my ($class, $begin, $end) = @_;
    if (defined $begin || defined $end) {
        my ($begin_dt, $end_dt) = map { 'DateTime::Format::W3CDTF'->parse_datetime($_) } grep { defined $_ } ($begin, $end);
    } else {
        $class->search;
    }
}

sub author {
    my ($self) = @_;
    InternDiary::MoCo::User->find($self->user_id);
}

sub extract_title {
    my ($class, $complexed) = @_;
    my ($title, @rest) = split "\n\n", $complexed;
    my $body = join "\n\n", @rest;
    ($title, $body);
}

1;
