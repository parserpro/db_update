package Table;
use common::sense;
use Data::Dumper;

use Column;

use Exporter 'import';
our @EXPORT = qw(table);

sub table {
    my $dbh  = $main::dbh;
    my $name = shift;
    my $res;

    eval {
        $res  = $dbh->selectall_arrayref("DESCRIBE `$name`", {Slice => {}});
    };

    my $self = {
        name => $name,
        def  => $res,
    };

    bless $self, __PACKAGE__;
}

sub exists {
    my $self = shift;

    return $self->{def} ? 1 : 0;
}

sub has_column {
    my ($self, $name) = @_;

    return $self->column($name)->exists ? 1 : 0;
}

1;
