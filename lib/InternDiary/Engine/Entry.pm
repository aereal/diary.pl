package InternDiary::Engine::Entry;
use strict;
use warnings;
use InternDiary::Engine -Base;
use InternDiary::MoCo::Entry;
use HTTP::Status;

sub default : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->param('id'))
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);
    $r->stash->param(
        entry => $entry
    );
}

sub create : Public {
    my ($self, $r) = @_;
    $r->follow_method;
}

sub _create_post {
    my ($self, $r) = @_;

    # $r->req->form(
    #     title => ['NOT_BLANK', 'ASCII'],
    #     body => ['NOT_BLANK', 'ASCII']
    # );

    if ($r->req->form->has_error) {
        # TODO
    } else {
        my $entry = $r->current_user->create_entry({
            title => $r->req->param('entry_title'),
            body => $r->req->param('entry_body'),
        });

        $r->res->redirect($r->entry_path(id => $entry->id));
    }
}

sub new_ : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->new;
    $r->stash->param(
        entry => $entry
    );
}

sub update : Public {
    my ($self, $r) = @_;
    $r->follow_method;
}

sub _update_post {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->param('id'))
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);

    # $r->req->form(
    #     title => ['NOT_BLANK', 'ASCII'],
    #     body => ['NOT_BLANK', 'ASCII']
    # );

    if ($r->req->form->has_error) {
        # TODO
    } else {
        $entry->update(
            title => $r->req->param('entry_title'),
            body => $r->req->param('entry_body'),
        );

        $r->res->redirect($r->entry_path(id => $entry->id));
    }
}

sub edit : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->param('id'))
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);
    $r->stash->param(
        entry => $entry
    );
}

1;
