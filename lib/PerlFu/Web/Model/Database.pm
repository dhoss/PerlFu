package PerlFu::Web::Model::Database;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'PerlFu::Schema',
    
);

1;
