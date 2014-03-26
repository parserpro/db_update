#!/usr/bin/env perl
use 5.10.0;
use common::sense;
use utf8;

use DBI;

use lib './lib';
use Table;

our $dbh = get_db();

if ( table('test1')->has_column('name') ) {
    say "Column 'name' found!";
}
else {
    say "No column 'name'";
}


if ( table('test1')->has_index('PRIMARY') ) {
    say "In 1";
    alter('test1', 'SQL here'); # this sub is needed for cache invalidation after schema has been changed
}
else {
    say "In 2";
}

#=======================================

sub alter {
    my ($table, $sql) = @_;
    table($table)->invalidate;
}







































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

    return DBI->connect(
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