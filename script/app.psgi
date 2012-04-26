# vim:set ft=perl:
use strict;
use warnings;
use lib glob 'modules/*/lib';
use lib 'lib';
use 5.010;


use UNIVERSAL::require;
use Path::Class;
use Plack::Builder;
use Cache::MemoryCache;
use Plack::Session;

my $namespace = 'InternDiary';
$namespace->use or die $@;

my $root = file(__FILE__)->parent->parent;

$ENV{GATEWAY_INTERFACE} = 1; ### disable plack's accesslog
$ENV{PLACK_ENV} = ($ENV{RIDGE_ENV} =~ /production|staging/) ? 'production' : 'development';

builder {
    unless ($ENV{PLACK_ENV} eq 'production') {
        enable "Plack::Middleware::Debug";
        enable "Plack::Middleware::Static",
            path => qr{^/(images|js|css)/},
            root => $root->subdir('static');
    }

    enable "Plack::Middleware::ReverseProxy";
    enable 'Session';

    mount '/auth' => builder {
        enable 'OAuth',
            on_success => sub {
                my ($self, $token) = @_;
                my $response = Plack::Response->new(200);
                my $session = Plack::Session->new($self->env);

                $session->set('oauth._.provider', $self->provider);

                given ($self->provider) {
                    when (/Twitter/) { $session->set('oauth._.user_name', $token->extra->{screen_name}) }
                }

                $response->redirect('/');
                $response->finalize;
            },
            # on_error => sub {
            #     [401, ['Content-Type' => 'text/plain'], ['Something went wrong']];
            # },
            providers => {
                'Twitter' => +{
                    consumer_key => '9jdZ7ECCouGASmkWBsvPrQ',
                    consumer_secret => '1J1sCXfYMbcsF1meI6V6mGToNQGe6nTEhZRYhfrduw',
                },
                # 'Hatena' => +{
                #     consumer_key => '/2h5X9zCHJwdTQ==',
                #     consumer_secret => 'ZZ0CcjWi+57WMHP5G6RnuyTkmhI=',
                # },
            };

        sub {
            my ($env) = @_;
            my $response = Plack::Response->new(200);
            $response->body('OAuth demo');
            $response->finalize;
        };
    };

    mount '/' => sub {
        my $env = shift;
        $namespace->process($env, {
            root => $root,
        });
    };
};

