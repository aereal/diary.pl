package InternDiary::App::CLI::Destroy;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Destroy - destroy the entry
