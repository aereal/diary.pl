package Plack::Middleware::OAuth::Hatena;
use strict;
use warnings;

sub config {
    +{
        version => 1,
        request_token_url => 'https://www.hatena.com/oauth/initiate',
        request_token_method => 'POST',
        access_token_url => 'https://www.hatena.com/oauth/token',
        access_token_method => 'POST',
        authorize_url => 'https://www.hatena.ne.jp/oauth/authorize',
    }
}

1;

