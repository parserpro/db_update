package Index;
use common::sense;
use utf8;
use Data::Dumper;

use Exporter 'import';
our @EXPORT = qw(index);

sub index {
    my $dbh  = $main::dbh;
    my ($table, $name) = @_;
    return unless $table;

    my $res;

    eval {
        $res  = $dbh->selectall_arrayref("SHOW FULL COLUMNS FROM `" . $table->{name} . "` LIKE ?", {Slice => {}}, $name);
    };

#    return if $@;

#warn Dumper($res);

    my $column = {
        table => $table->{name},
        name  => $name,
        def   => $res ? $res->[0] : undef,
    };

    bless $column, __PACKAGE__;
}

sub exists {
    my $column = shift;
    return unless $column;
    return $column->{def} ? 1 : 0;
}

sub has_type {
    my ($column, $type) = @_;
    return unless $column;
    return $column->type eq lc($type) ? 1 : 0;
}

sub type {
    my $column = shift;
    return unless $column;
    return lc($column->{def}->{type});
}

sub default {
    my $column = shift;
    return unless $column;
    return lc($column->{def}->{default});
}

1;
