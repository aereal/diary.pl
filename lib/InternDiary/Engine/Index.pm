package InternDiary::Engine::Index;
use strict;
use warnings;

use InternDiary::Engine -Base;
use InternDiary::App;
use InternDiary::MoCo::User;
use InternDiary::MoCo::Entry;

sub default : Public {
    my ($self, $r) = @_;
    $r->current_user;
    $r->stash->param(
        entries => InternDiary::MoCo::Entry->page($r->req->param('page'))->to_a,
    );
}

1;
