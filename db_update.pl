#!/usr/bin/env perl
use 5.10.0;
use common::sense;
use utf8;

use Getopt::Long;
use DBI;

use lib './lib';
use Table;
use Schema;

our $show = '';
my $host = '127.0.0.1';
my $base = 'fantlab';
my $port = '3306';
my $user = 'root';
my $pass = '';
our $real = 0;

GetOptions(
    'show!'    => \$show,
    'host|h:s' => \$host,
    'base|b:s' => \$base,
    'port|P:s' => \$port,
    'user|u:s' => \$user,
    'password|p:s' => \$pass,
    'real|r!' => \$real,
);

our $dbh = get_db();

say 'Working ' . ( $real ? 'IN' : 'NOT' ) . ' real!';

#--------------------------- Put your SQL below this line
# TODO: implement reading SQL files from the directory

say schema('fantlab')->collation;

unless ( table('test1')->has_index('PRIMARY') ) {
    say "In 1";
    table('test1')->alter('SQL here');
}
else {
    say "In 2";
}

#=======================================








































sub get_db {
    my %config = (
        'dsn'        => $ENV{'mysqlconnection'} || qq~dbi:mysql:database=$base;host=$host;port=$port;mysql_connect_timeout=5~,
        'user'       => $ENV{'mysqluser'}       || $user,
        'password'   => $ENV{'mysqlpassword'}   || $pass,
    );

    return DBI->connect(
        $config{dsn},
        $config{user},
        $config{password},
        {
            RaiseError       => 1,
            PrintError       => 0,
            FetchHashKeyName => 'NAME_lc',
        },
    );
}