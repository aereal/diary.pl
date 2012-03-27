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

1;
