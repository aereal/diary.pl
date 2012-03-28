package InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent 'InternDiary::MoCo';
use InternDiary::MoCo::User;

__PACKAGE__->table('entries');

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
