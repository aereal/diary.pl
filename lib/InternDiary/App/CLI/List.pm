package InternDiary::App::CLI::List;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;

use InternDiary::App;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

sub run {
    my ($self) = @_;
    for (@{$self->app->list_entries}){
        print sprintf "%s: %s\n", $_->created_at->iso8601, $_->title;
    }
}

1;
