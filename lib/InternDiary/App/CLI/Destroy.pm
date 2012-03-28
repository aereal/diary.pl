package InternDiary::App::CLI::Destroy;
use strict;
use warnings;
use parent qw/CLI::Dispatch::Command/;
use Try::Tiny;

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
    try {
        $self->app->destroy_entry($entry_id);
    } catch {
        warn 'Failed to destroy entry';
    } finally {
        print 'Successfully destroyed entry', "\n" unless @_;
    };
}

1;

__END__

=head1 NAME

InternDiary::App::CLI::Destroy - destroy the entry
