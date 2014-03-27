package Schema;
use common::sense;
use utf8;

use base 'Object';
use Table;

use Exporter 'import';
our @EXPORT = qw(table);

our %cache;

sub schema {
    return __PACKAGE__->SUPER::new(@_);
}

1;
