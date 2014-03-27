package Object;
use common::sense;
use utf8;

use Data::Dumper;

my %cache;

my %sql = (
    Schema => sub {},
    Table  => sub { 'DESCRIBE `' . $_[0] . '`' },
    Column => sub { 'SHOW FULL COLUMNS FROM `' . $_[0] . '` LIKE ?' },
    Index  => sub { 'SHOW INDEX FROM `' . $_[0] . '` WHERE key_name = ?' },
);

my %params = (
    Schema => sub { () },
    Table  => sub { () },
    Column => sub { $_[1] },
    Index  => sub { $_[1] },
);

sub new {
    my ( $class, $table, $name ) = @_;
    return unless $table;
    $table = ref $table ? $table->{table} : $table;

    return $cache{$class}->{$table}          if exists $cache{$class}->{$table} && ! $name;
    return $cache{$class}->{$table}->{$name} if exists $cache{$class}->{$table} && exists $cache{$class}->{$table}->{$name};

    my $res;

    eval {
        $res  = $main::dbh->selectall_arrayref( $sql{$class}->($table, $name), {Slice => {}}, $params{$class}->($table, $name) );
    };

    my $obj = {
        table => $table,
        (
            $name
              ? (name => $name)
              : ()
        ),
        def   => $res,
    };

    bless $obj, $class;
    $class eq 'Table'
      ? $cache{$class}->{$table} = $obj
      : $cache{$class}->{$table}->{$name} = $obj;

    return $obj;
}

sub exists {
    my $obj = shift;
    return unless $obj;
    return $obj->{def} ? 1 : 0;
}

sub invalidate {
    my $obj = shift;
    my $class = ref $obj;
    return unless ref $class;

    if ( $class eq 'Table' ) {
        delete $cache{'Table'}->{$class->{name}};
        delete $cache{'Column'}->{$class->{name}};
        delete $cache{'Index'}->{$class->{name}};
    }
    else {
        delete $cache{ref $class}->{$class->{table}}->{$class->{name}};
    }
}

sub alter {
    my ($obj, $sql) = @_;

    if ( $main::show ) {
        say "SQL: $sql";
    }

    if ( $main::real ) {
        $main::dbh->do($sql);
        $obj->invalidate;
    }
}


1;
