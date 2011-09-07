package PerlFu::Web::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH       => [ PerlFu::Web->path_to( 'root', 'site' ), ],
    WRAPPER            => 'wrapper',
    render_die         => 1,
    RECURSION          => 1,
    CATALYST_VAR       => 'c'
);

=head1 NAME

PerlFu::Web::View::HTML - TT View for PerlFu::Web

=head1 DESCRIPTION

TT View for PerlFu::Web.

=head1 SEE ALSO

L<PerlFu::Web>

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
