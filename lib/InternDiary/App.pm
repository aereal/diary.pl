package InternDiary::App;
use strict;
use warnings;
use InternDiary::MoCo::User;
use InternDiary::MoCo::Entry;
use Try::Tiny;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub current_user {
    InternDiary::MoCo::User->search->first;
}

sub register {
    my ($self, $new_name) = @_;
    die 'No username given' unless defined $new_name;
    try {
        InternDiary::MoCo::User->create(name => $new_name);
    } catch {
        die 'Given name is already taken';
    };
}

sub login {
    my ($self, $name) = @_;
    die 'No username given' unless defined $name;
    InternDiary::MoCo::User->find(name => $name) or
        die 'Given name is not found';
}

sub create_entry {
    my ($self, $complexed) = @_;
    my ($title, @rest) = split "\n", $complexed;
    my $body = join "\n", @rest;
    $self->current_user->create_entry({title => $title, body => $body});
}

1;
