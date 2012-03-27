package InternDiary::App;
use strict;
use warnings;
use InternDiary::MoCo::User;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub register {
    my ($self, $new_name) = @_;
    die 'No username given' unless defined $new_name;
    InternDiary::MoCo::User->create(name => $new_name);
}

1;
