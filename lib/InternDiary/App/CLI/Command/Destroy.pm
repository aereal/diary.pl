package InternDiary::App::CLI::Command::Destroy;
use strict;
use warnings;
use parent qw/InternDiary::App::CLI::Base/;
use Try::Tiny;

use InternDiary::MoCo::Entry;

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

InternDiary::App::CLI::Command::Destroy - destroy the entry
