package InternDiary::MoCo::User;
use strict;
use warnings;
use parent 'InternDiary::MoCo';

__PACKAGE__->table('users');
__PACKAGE__->inflate_column(
    created_at => {
        inflate => sub {
            return unless $_[0] && $_[0] ne '0000-00-00 00:00:00';
        },
    },
);

1;
