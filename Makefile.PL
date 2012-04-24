use inc::Module::Install;

name 'InternDiary';
version '0.0.1';

requires 'Try::Tiny';
requires 'Class::Data::Accessor';
requires 'List::MoreUtils';

test_requires 'Test::Name::FromLine';
test_requires 'Test::Fatal';
test_requires 'DBIx::RewriteDSN';
test_requires 'Test::Mock::Guard';

WriteAll;
