package InternDiary::App::CLI::Auth;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use InternDiary::MoCo::User;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

sub run {
    my ($self, $user_name) = @_;
    unless (defined $user_name && $user_name ne '') {
        die sprintf '$user_name (%s) is not given', $user_name;
    }
    my %query = (name => $user_name);
    if (InternDiary::MoCo::User->find(%query) || InternDiary::MoCo::User->create(%query)) {
        $self->log(info => "You are authenticated as $user_name");
    }
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Auth - be authenticated as
