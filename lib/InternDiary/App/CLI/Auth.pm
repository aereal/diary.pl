package InternDiary::App::CLI::Auth;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use Try::Tiny;
use InternDiary::App;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

sub run {
    my ($self, $user_name) = @_;
    try {
        $self->app->login($user_name);
    } catch {
        $self->app->register($user_name);
    }
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Auth - be authenticated as
