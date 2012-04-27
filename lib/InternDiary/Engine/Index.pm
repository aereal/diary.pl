package InternDiary::Engine::Index;
use strict;
use warnings;
use 5.010;
use DateTime;
use DateTime::Format::W3CDTF;

use InternDiary::Engine -Base;

sub default : Public {
    my ($self, $r) = @_;
    my $model = 'InternDiary::MoCo::Entry';
    my $pager = $r->pager($model, $r->req->param('page') || 1, $r->config->app_config->{per_page});
    my $entries = $r->paginate($model, $pager);
    $r->stash->param(
        entries => $entries->to_a,
        pager => $pager,
    );

    # !!!!!!!!!! BK !!!!!!!!!!
    # URIの拡張子がアクションを表す謎規約のため、フォーマット表すものとして拡張子が使いものにならない
    # アクションが見つからなかった場合、Engine#defaultへフォールバックされる
    # このため、Ridge::URI::Lite#_action から判断することにする
    # !!!!!!!!!! BK !!!!!!!!!!
    given ($r->req->uri->_action) {
        when (/atom/) {
            my $params = {
                site_title => $r->title,
                site_iri => $r->config->app_config->{uri}->as_iri,
                atom_url => $r->config->app_config->{uri}->path($r->entries_atom_path),
            };
            $params->{last_modified_at} = $entries->first->created_at
                ->set_time_zone($r->config->app_config->{time_zone})
                ->set_formatter('DateTime::Format::W3CDTF')
                if defined $entries->first;

            $r->res->content_type('application/atom+xml');
            $r->view->filename('index.atom');
            $r->stash->param(%$params);
        }
    }
}

1;
