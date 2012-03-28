package InternDiary::App::CLI::New;
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

sub run {
    my ($self, @args) = @_;
    my $editor = $ENV{EDITOR} or die '$EDITOR is not set';
    my $tempfile = File::Temp->new;
    $self->log(debug => "\$EDITOR is $editor");
    $self->log(debug => '$tempfile->filename is ' . $tempfile->filename);
    system $editor, $tempfile->filename;
    close $tempfile;
    my $entry = $self->app->create_entry(file($tempfile->filename)->slurp);
    print $entry ? 'Successfully created entry!' : 'Failed to create entry';
    print "\n"
}

1;
