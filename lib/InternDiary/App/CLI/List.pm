package InternDiary::App::CLI::List;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use List::MoreUtils qw/apply/;

use InternDiary::App;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

sub run {
    my ($self) = @_;
    for (@{$self->app->list_entries}){
        print sprintf "ID:%s %s (%s)\n", $_->id, $_->title =~ s/\n+//r, $_->created_at->iso8601;
    }
}

1;
