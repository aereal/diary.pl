package InternDiary;
use strict;
use warnings;
use parent qw/Ridge/;
use InternDiary::MoCo::User;

__PACKAGE__->configure;

sub current_user {
    my ($self) = @_;
    InternDiary::MoCo::User->search->first;
}

1;
