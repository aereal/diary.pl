package InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent 'InternDiary::MoCo';
use InternDiary::MoCo::User;
use DateTime::Format::W3CDTF;
use DateTime::Format::MySQL;
use Text::Markdown qw/markdown/;

__PACKAGE__->table('entries');

sub search_with_duration {
    my ($class, $begin, $end, %where) = @_;
    if (defined $begin || defined $end) {
        my ($begin_dt, $end_dt) = map { defined $_ && $_ ne '' ? 'DateTime::Format::W3CDTF'->parse_datetime($_) : DateTime->now } ($begin, $end);
        $class->search(where => {%where, created_at => {
            -between => [
                DateTime::Format::MySQL->format_datetime($begin_dt),
                DateTime::Format::MySQL->format_datetime($end_dt)
            ]
        }});
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

sub formatted_body {
    my ($self) = @_;
    markdown($self->body);
}

sub TO_JSON {
    my ($self) = @_;
    my $h = {};
    $h->{$_} = $self->$_ for qw/id title body user_id/;
    $h->{created_at} = DateTime::Format::W3CDTF->format_datetime($self->created_at);
    $h->{updated_at} = DateTime::Format::W3CDTF->format_datetime($self->updated_at);
    $h;
}

1;
