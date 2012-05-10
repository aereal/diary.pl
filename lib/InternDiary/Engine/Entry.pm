package InternDiary::Engine::Entry;
use strict;
use warnings;
use InternDiary::Engine -Base;
use InternDiary::MoCo::Entry;
use HTTP::Status;
use JSON::XS;

sub default : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->uri->param('id'))
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);
    $r->stash->param(
        entry => $entry,
        page_title => $entry->title,
    );
}

sub create : Public {
    my ($self, $r) = @_;
    $r->follow_method;
}

sub _create_post {
    my ($self, $r) = @_;

    $r->logged_in
        or Ridge::Exception::RequestError->throw(code => RC_FORBIDDEN);

    # $r->req->form(
    #     title => ['NOT_BLANK', 'ASCII'],
    #     body => ['NOT_BLANK', 'ASCII']
    # );

    if ($r->req->form->has_error) {
        # TODO
    } else {
        my $entry = $r->current_user->create_entry({
            title => $r->req->parameters->{entry_title},
            body => $r->req->parameters->{entry_body},
        });

        $r->res->redirect($r->entry_path(id => $entry->id));
    }
}

sub new_ : Public {
    my ($self, $r) = @_;

    $r->logged_in
        or Ridge::Exception::RequestError->throw(code => RC_FORBIDDEN);

    my $entry = InternDiary::MoCo::Entry->new;
    $r->stash->param(
        entry => $entry,
        page_title => '日記を書く',
    );
}

sub update : Public {
    my ($self, $r) = @_;
    $r->follow_method;
}

sub _update_post {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->parameters->{id})
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);

    $r->has_permission_for($entry)
        or Ridge::Exception::RequestError->throw(code => RC_FORBIDDEN);

    # $r->req->form(
    #     title => ['NOT_BLANK', 'ASCII'],
    #     body => ['NOT_BLANK', 'ASCII']
    # );

    if ($r->req->form->has_error) {
        # TODO
    } else {
        $entry->title($r->req->parameters->{entry_title});
        $entry->body($r->req->parameters{entry_body});
        $entry->save;

        if ($r->req->env->{HTTP_X_REQUESTED_WITH} eq 'XMLHttpRequest') {
            my $content = {
                title => $entry->title,
                body => $entry->body,
                formattedBody => $entry->formatted_body,
            };
            $r->res->content_type('application/json');
            $r->res->content(JSON::XS->new->latin1->encode($content));
        } else {
            $r->res->redirect($r->entry_path(id => $entry->id));
        }
    }
}

sub edit : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->parameters->{id})
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);

    $r->has_permission_for($entry)
        or Ridge::Exception::RequestError->throw(code => RC_FORBIDDEN);

    $r->stash->param(
        entry => $entry,
        page_title => '' . $entry->title . 'を編集する',
    );
}

sub destroy : Public {
    my ($self, $r) = @_;
    $r->follow_method;
}

sub _destory_post {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->retrieve($r->req->parameters->{id})
        or Ridge::Exception::RequestError->throw(code => RC_NOT_FOUND);

    $r->has_permission_for($entry)
        or Ridge::Exception::RequestError->throw(code => RC_FORBIDDEN);

    $entry->delete;

    $r->res->redirect($r->entries_path);
}

1;
