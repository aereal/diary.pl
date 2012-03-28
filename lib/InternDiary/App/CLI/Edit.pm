package InternDiary::App::CLI::Edit;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use File::Temp;
use Path::Class qw/file/;

use InternDiary::App;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

1;
