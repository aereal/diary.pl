package InternDiary::Config;
use strict;
use warnings;
use parent qw/Ridge::Config/;
use Path::Class qw/file/;

my $root = file(__FILE__)->dir->parent->parent->parent;

__PACKAGE__->setup({
    root => __PACKAGE__->find_root,
    namespace => 'InternDiary',
    charset => 'utf-8',
    ignore_config => 1,
    static_path => [
        '^/images\/',
        '^/js\/',
        '^/css\/',
        '^/favicon\.ico',
    ],
    URI => {
        use_lite => 1,
        filter => \&uri_filter,
    },
    app_config => {
        default => {
            uri => URI->new('http://local.hatena.ne.jp:3000/'),
        },
    }
});

sub uri_filter {
    my ($uri) = @_;
    my $path = $uri->path;
    $uri;
}

1;
