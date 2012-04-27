package InternDiary;
use strict;
use warnings;
use parent qw/Ridge/;
use URI;
use URI::QueryParam;
use Plack::Session;
use POSIX qw/ceil/;

use InternDiary::MoCo::User;

__PACKAGE__->configure;

sub title {
    my ($self) = @_;
    my $delimiter = $self->config->app_config->{title_delimiter} || ' - ';
    my $site_title = $self->config->app_config->{site_title};
    my $page_title = $self->stash->param('page_title');
    join $delimiter, grep { defined $_ } ($page_title, $site_title);
}

sub session {
    my ($self) = @_;
    Plack::Session->new($self->req->env);
}

sub current_auth_provider {
    my ($self) = @_;
    $self->session->get('oauth._.provider');
}

sub current_user_name {
    my ($self) = @_;
    $self->session->get('oauth._.user_name');
}

sub current_user {
    my ($self) = @_;
    InternDiary::MoCo::User->find(name => $self->current_user_name);
}

sub logged_in {
    my ($self) = @_;
    !!($self->current_auth_provider && $self->current_user_name);
}

sub has_permission_for {
    my ($self, $entry) = @_;
    $self->logged_in && $self->current_user->is_author_of($entry);
}

sub paginate {
    my ($self, $model, $pager, %options) = @_;

    $model->search(
        limit => $pager->{per_page_count},
        offset => $pager->{per_page} * ($pager->{current_page} - 1),
        %options
    );
}

sub pager {
    my ($self, $model, $page, $per_page) = @_;

    my %pager = (
        current_page => $page,
        total_count => $model->count,
        per_page_count => $per_page
    );
    $pager{total_pages} = ceil($pager{total_count} / $pager{per_page_count});
    $pager{next_page} = $pager{current_page} + 1
        if $pager{current_page} > 0 && $pager{current_page} < $pager{total_pages};
    $pager{prev_page} = $pager{current_page} - 1
        if $pager{current_page} > 1 && $pager{current_page} <= $pager{total_pages};
    $pager{pageable} = (defined $pager{next_page}) || (defined $pager{prev_page});
    \%pager;
}

sub entry_iri {
    my ($self, $entry) = @_;
    $self->entry_url($entry)->as_iri;
}

sub entry_url {
    my ($self, $entry) = @_;
    my $u = $self->config->app_config->{uri};
    $u->path($self->entry_path($entry));
    $u;
}

sub entries_path { '/' }

sub entries_atom_path { '/index.atom' }

sub new_entry_path { '/entry.new_' }

sub create_entry_path { '/entry.create' }

sub entry_path {
    shift;
    my $u = URI->new('/entry');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

sub edit_entry_path {
    shift;
    my $u = URI->new('/entry.edit');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

sub update_entry_path {
    shift;
    my $u = URI->new('/entry.update');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

sub destroy_entry_path {
    shift;
    my $u = URI->new('/entry.destroy');
    $u->query_form_hash(@_);
    $u->canonical->as_string;
}

1;
