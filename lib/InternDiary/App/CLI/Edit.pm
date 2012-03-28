package InternDiary::App::CLI::Edit;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use File::Temp;
use Path::Class qw/file/;

use InternDiary::MoCo::Entry;
use InternDiary::App;

sub app {
    my ($self) = @_;
    $self->{app} ||= InternDiary::App->new;
}

sub run {
    my ($self, $entry_id, @rest) = @_;
    my $entry;
    if (defined $entry_id) {
        $entry = InternDiary::MoCo::Entry->find(id => $entry_id);
        die "Entry (id: $entry_id) not found" unless $entry;
    } else {
        die $self->usage(1);
    }
    my $editor = $ENV{EDITOR} or die '$EDITOR is not set';
    my $tempfile = File::Temp->new;
    $self->log(debug => "\$EDITOR is $editor");
    $self->log(debug => '$tempfile->filename is ' . $tempfile->filename);
    print $tempfile join "$/$/", ($entry->title, $entry->body);
    system $editor, $tempfile->filename;
    close $tempfile;
    my $updated_entry = $self->app->update_entry($entry_id, file($tempfile->filename)->slurp);
    print $updated_entry ? 'Successfully updated entry!' : 'Failed to update entry';
    print "\n"
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Edit - edit the entry
