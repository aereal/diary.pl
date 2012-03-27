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

1;
