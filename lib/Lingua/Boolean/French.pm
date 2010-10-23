use strict;
use warnings;
use utf8;
package Lingua::Boolean::French;
# ABSTRACT: provides French to Lingua::Boolean

=head1 DESCRIPTION

This module provides rules for French to L<Lingua::Boolean>.

=cut

our $LANG = 'fr';
our $LANGUAGE = 'Français';

our $match;
$match->{True}  = [qr{^oui$}i, qr{^ok$}i, qr{^vraie?$}i, qr{^[1-9]$}];
$match->{False} = [qr{^n(?:on?)?$}i, qr{^faux$}i, qr{^0$}];

1;

__END__
