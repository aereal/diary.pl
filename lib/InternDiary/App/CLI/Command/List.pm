package InternDiary::App::CLI::Command::List;
use strict;
use warnings;
use parent qw/InternDiary::App::CLI::Base/;
use List::MoreUtils qw/apply/;

sub run {
    my ($self, @args) = @_;
    my @duration = $args[0] ? split /:/, $args[0] : ();
    for (@{$self->app->list_entries(@duration)}){
        print sprintf "ID:%s %s (%s)\n", $_->id, $_->title =~ s/\n+//r, $_->created_at->iso8601;
    }
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Command::List - search your entries

=head1 SYNOPSIS

diary.pl list
diary.pl list [[begin_datetime]:[end_datetime]]

$begin_datetime and $end_datetime should be valid W3CDTF format
