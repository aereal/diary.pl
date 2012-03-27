package InternDiary::MoCo::Entry;
use strict;
use warnings;
use parent 'InternDiary::MoCo';

__PACKAGE__->table('entries');
__PACKAGE__->inflate_column(
    created_at => {
        inflate => sub {
            $_[0] && $_[0] ne '0000-00-00 00:00:00' ? DateTime::Format::MySQL->parse_datetime($_[0]) : ();
        },
        deflate => sub {
            DateTime::Format::MySQL->format_datetime(shift);
        },
    },
);

1;
