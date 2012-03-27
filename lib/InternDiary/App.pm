package InternDiary::App;
use strict;
use warnings;
use InternDiary::MoCo::User;
use Try::Tiny;
use Carp;

sub new {
    my ($class) = @_;
    bless {}, $class;
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
}

1;
