#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib 'lib';
use lib glob "$FindBin::Bin/modules/*/lib";
use CLI::Dispatch;

CLI::Dispatch->run('InternDiary::App::CLI::Command');
