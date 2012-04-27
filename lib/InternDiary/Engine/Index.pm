package InternDiary::Engine::Index;
use strict;
use warnings;

use InternDiary::Engine -Base;
use InternDiary::App;
use InternDiary::MoCo::User;
use InternDiary::MoCo::Entry;

sub default : Public {
    my ($self, $r) = @_;
    my $model = 'InternDiary::MoCo::Entry';
    my $pager = $r->pager($model, $r->req->param('page') || 1, $r->config->{app_config}->{default}->{per_page});
    $r->stash->param(
        entries => $r->paginate($model, $pager)->to_a,
        pager => $pager,
    );
}

1;
