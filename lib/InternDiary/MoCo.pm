package InternDiary::MoCo;
use strict;
use warnings;
use FindBin;
use lib glob "$FindBin::Bin/../module/*/lib";
use parent 'DBIx::MoCo';

__PACKAGE__->db_object('InternDiary::Database');

1;
