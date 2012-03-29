package InternDiary::App::CLI::Base;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command Class::Data::Accessor/;

use InternDiary::App;

__PACKAGE__->mk_classaccessor('auth_required' => 1);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    if ($self->auth_required && !defined $self->app->current_user) {
        die 'Authentication required!';
    }

    $self;
}

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

1;
