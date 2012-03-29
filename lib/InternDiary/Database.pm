package InternDiary::Database;
use strict;
use warnings;
use FindBin;
use lib glob "$FindBin::Bin/../modules/*/lib";
use parent 'DBIx::MoCo::DataBase';

__PACKAGE__->dsn('dbi:mysql:dbname=intern_diary_aereal');
__PACKAGE__->username('root');
__PACKAGE__->password('');

1;
