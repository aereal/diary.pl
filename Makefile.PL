use inc::Module::Install;

name 'InternDiary';
version '0.0.1';

requires 'Try::Tiny';
requires 'Class::Data::Accessor';
requires 'List::MoreUtils';
requires 'HTTP::Server::Simple::PSGI';
requires 'Cache::MemoryCache';
requires 'HTTP::MobileAgent';
requires 'Plack::Middleware::Debug';

test_requires 'Test::Name::FromLine';
test_requires 'Test::Fatal';
test_requires 'DBIx::RewriteDSN';
test_requires 'Test::Mock::Guard';
test_requires 'POE::Sugar::Args';
test_requires 'File::MimeInfo';

WriteAll;
