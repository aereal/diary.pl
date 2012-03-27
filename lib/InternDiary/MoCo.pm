package InternDiary::MoCo;
use strict;
use warnings;
use FindBin;
use lib glob "$FindBin::Bin/../module/*/lib";
use parent 'DBIx::MoCo';

__PACKAGE__->db_object('InternDiary::Database');
__PACKAGE__->inflate_column(
    created_at => {
        inflate => sub {
            $_[0] && $_[0] ne '0000-00-00 00:00:00' ? DateTime::Format::MySQL->parse_datetime($_[0]) : ();
        },
        deflate => sub {
            DateTime::Format::MySQL->format_datetime(shift);
        },
    },
    updated_at => {
        inflate => sub {
            $_[0] && $_[0] ne '0000-00-00 00:00:00' ? DateTime::Format::MySQL->parse_datetime($_[0]) : ();
        },
        deflate => sub {
            DateTime::Format::MySQL->format_datetime(shift);
        },
    },
);

1;
