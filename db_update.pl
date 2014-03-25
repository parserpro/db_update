#!/usr/bin/env perl
use 5.10.0;
use common::sense;

use DBI;
use Test::More;
use Data::Dumper;

use lib './lib';
use Table;

our $dbh;

get_db();

plan tests => 6;

is(table('test')->exists, 0, 'Not exists');
is(table('test1')->exists, 1, 'Exists' );
is(table('test1')->has_column('fake'), 0, 'Not existent column');
is(table('test1')->has_column('name'), 1, 'Existent column');
is(table('test1')->column('name')->has_type('int'), 0, 'Wrong type of column');
is(table('test1')->column('name')->has_type('varchar(45)'), 0, 'Right type of column');
















































sub get_db {
my $server = {
    base => 'test',
    host => '127.0.0.1',
    port => 3311,
};

my %config = (
    'dsn'        => $ENV{'mysqlconnection'} || qq~dbi:mysql:database=$server->{base};host=$server->{host};port=$server->{port}~,
    'user'       => $ENV{'mysqluser'}       || 'root',
    'password'   => $ENV{'mysqlpassword'}   || '',
);
my $dsn = "$config{dsn};mysql_connect_timeout=5";

$dbh = DBI->connect(
    $dsn,
    $config{user},
    $config{password},
    {
        RaiseError       => 1,
        PrintError       => 0,
        FetchHashKeyName => 'NAME_lc',
    },
);
}