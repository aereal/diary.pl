package InternDiary::MoCo;
use strict;
use warnings;
use FindBin;
use lib glob "$FindBin::Bin/../module/*/lib";
use parent 'DBIx::MoCo';
use DateTime::Format::MySQL;

use InternDiary::Database;

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

__PACKAGE__->add_trigger(
    before_create => sub {
        my ($class, $args) = @_;
        for my $column (qw/created_at updated_at/){
            if ($class->has_column($column) && !defined $args->{$column}) {
                $args->{$column} = DateTime->now(time_zone => 'UTC', formatter => 'DateTime::Format::MySQL');
            }
        }
    }
);

__PACKAGE__->add_trigger(
    before_update => sub {
        my ($class, $self, $args) = @_;
        for my $column (qw/updated_at/){
            if ($class->has_column($column) && !defined $args->{$column}) {
                $args->{$column} = DateTime->now(time_zone => 'UTC', formatter => 'DateTime::Format::MySQL');
            }
        }
    }
);

1;
