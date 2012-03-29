package InternDiary::App::CLI::Command::New;
use strict;
use warnings;
use parent qw/InternDiary::App::CLI::Base/;
use File::Temp;
use Path::Class qw/file/;

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

__END__

=head1 NAME

InternDiary::App::CLI::Command::New - create a new entry

=head1 SYNOPSIS

diary.pl new

=head1 DESCRIPTION

=head2 FORMAT

First line is title, then a blank line appears, and the body follows

    (ENTRY.TXT)
    My New Entry

    Hello World!
    This is my new entry!
