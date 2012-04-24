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

sub new_ : Public {
    my ($self, $r) = @_;
    my $entry = InternDiary::MoCo::Entry->new;
    $r->stash->param(
        entry => $entry
    );
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
