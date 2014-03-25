package Column;
use common::sense;
use utf8;
use Data::Dumper;

use Exporter 'import';
our @EXPORT = qw(column);

sub column {
    my $dbh  = $main::dbh;
    my ($table, $name) = @_;
    my $res;

    eval {
        $res  = $dbh->selectall_arrayref("SHOW FULL COLUMNS FROM `" . $table->{name} . "` LIKE ?", {Slice => {}}, $name);
    };

    if ( $@ ) {
        return undef;
    }

    my $column = {
        table => $table->{name},
        name  => $name,
        def   => $res ? $res->[0] : undef,
    };

    bless $column, __PACKAGE__;
}

sub exists {
    my $column = shift;

    return $column->{def} ? 1 : 0;
}

sub has_type {
    my ($column, $type) = @_;

    return $column->type eq lc($type) ? 1 : 0;
}

sub type {
    my $column = shift;

    return lc($column->{def}->{type});
}

1;
