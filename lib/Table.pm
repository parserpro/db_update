package Table;
use common::sense;
use utf8;
use Data::Dumper;

use Column;
use Index;

use Exporter 'import';
our @EXPORT = qw(table);

our %cache;

sub table {
    my $dbh  = $main::dbh;
    my $name = shift;
    return unless $name;
    return $cache{$name} if exists $cache{$name};

    my $res;

    eval {
        $res  = $dbh->selectall_arrayref("DESCRIBE `$name`", {Slice => {}});
    };

#warn Dumper($res);

    my $table = {
        name => $name,
        def  => $res,
    };

    bless $table, __PACKAGE__;
    $cache{$name} = $table;
    return $table;
}

sub exists {
    my $table = shift;
    return unless $table;
    return $table->{def} ? 1 : 0;
}

sub has_column {
    my ($table, $name) = @_;
    return unless $table;
    return $table->column($name)->exists ? 1 : 0;
}

sub columns {
    my $table = shift;
    return unless $table;
    return map {$_->{field}} @{$table->{def}};
}

sub has_index {
    my ($table, $name) = @_;
    return unless $table;
    return $table->index($name)->exists ? 1 : 0;
}

1;
