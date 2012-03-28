package InternDiary::App;
use strict;
use warnings;
use InternDiary::MoCo::User;
use InternDiary::MoCo::Entry;
use Try::Tiny;
use DateTime::Format::W3CDTF;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub current_user {
    InternDiary::MoCo::User->search->first;
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
    InternDiary::MoCo::User->find(name => $name) or
        die 'Given name is not found';
}

sub list_entries {
    my ($self, $begin, $end) = @_;
    if (defined $begin || defined $end) {
        my ($begin_dt, $end_dt) = map { 'DateTime::Format::W3CDTF'->parse_datetime($_) } grep { defined $_ } ($begin, $end);
    } else {
        $self->current_user->entries->to_a;
    }
}

sub create_entry {
    my ($self, $complexed) = @_;
    my ($title, $body) = InternDiary::MoCo::Entry->extract_title($complexed);
    $self->current_user->create_entry({title => $title, body => $body});
}

sub update_entry {
    my ($self, $id, $complexed) = @_;
    my $entry = InternDiary::MoCo::Entry->find(id => $id);
    my ($title, $body) = InternDiary::MoCo::Entry->extract_title($complexed);
    $entry->update(title => $title, body => $body);
}

sub destroy_entry {
    my ($self, $id) = @_;
    my $entry = InternDiary::MoCo::Entry->find($id);
    die 'Entry not found' unless $entry;
    $entry->delete;
}

1;
