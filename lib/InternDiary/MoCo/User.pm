package InternDiary::MoCo::User;
use strict;
use warnings;
use parent 'InternDiary::MoCo';
use DateTime::Format::MySQL;
use InternDiary::MoCo::Entry;

__PACKAGE__->table('users');

sub create_entry {
    my ($self, $args) = @_;
    InternDiary::MoCo::Entry->create((%$args, (user_id => $self->id)));
}

sub entries {
    my ($self) = @_;
    InternDiary::MoCo::Entry->search(where => {user_id => $self->id}, order => 'created_at DESC');
}

sub is_author_of {
    my ($self, $entry) = @_;
    $self->id == $entry->user_id;
}

1;
