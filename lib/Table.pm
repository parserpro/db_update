package Table;
use common::sense;
use utf8;
use Data::Dumper;

use base 'Object';
use Column;
use Index;

use Exporter 'import';
our @EXPORT = qw(table);

our %cache;

sub table {
    return __PACKAGE__->SUPER::new(@_);
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
