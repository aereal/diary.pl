package InternDiary::App::CLI::Command::Auth;
use strict;
use warnings;
use parent qw/InternDiary::App::CLI::Base/;
use Try::Tiny;

__PACKAGE__->auth_required(0);

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

InternDiary::App::CLI::Command::Auth - be authenticated as

=head1 SYNOPSIS

diary.pl auth {user_name}
