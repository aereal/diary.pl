package InternDiary::App;
use strict;
use warnings;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub register {
    my ($self, $new_name) = @_;
    die 'No username given' unless defined $new_name;
}

1;
