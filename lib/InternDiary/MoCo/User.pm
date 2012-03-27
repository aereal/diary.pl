package InternDiary::MoCo::User;
use strict;
use warnings;
use parent 'InternDiary::MoCo';
use DateTime;

__PACKAGE__->table('users');
__PACKAGE__->inflate_column(
    created_at => {
        inflate => sub {
            $_[0] && $_[0] ne '0000-00-00 00:00:00' ? DateTime->new(year => 1992, month => 5, day => 5) : ();
        },
    },
);

1;
