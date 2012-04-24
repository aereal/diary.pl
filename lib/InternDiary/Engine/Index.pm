package InternDiary::Engine::Index;
use strict;
use warnings;
use InternDiary::Engine -Base;
use InternDiary::App;
use InternDiary::MoCo::User;
#use InternDiary::MoCo::Entry;

sub default : Public {
    my ($self, $r) = @_;
    $r->stash->param(
        entries => $r->current_user->entries
    );
}

1;
