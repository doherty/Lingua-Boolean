package Lingua::Boolean::French;
# ABSTRACT: DEPRECATED - provides French rules to Lingua::Boolean
use strict;
use warnings;
use utf8;
# VERSION

=head1 DESCRIPTION

This module provides rules for French to C<Lingua::Boolean>.

=cut

=head1 METHODS

=head2 new

C<new()> creates a new C<Lingua::Boolean::French> object. This is
intended for consumption by L<Lingua::Boolean> only.

=cut

sub new {
    my $class = shift;

    my $LANG = 'fr';
    my $LANGUAGE = 'Français';

    my $match;
    $match->{True}  = [qr{^oui$}i, qr{^ok$}i, qr{^vraie?$}i, qr{^[1-9]$}];
    $match->{False} = [qr{^n(?:on?)?$}i, qr{^faux$}i, qr{^0$}];

    my $self = {
        LANG => $LANG,
        LANGUAGE => $LANGUAGE,
        match => $match,
    };
    bless $self, $class;
    return $self;
}

=head1 SEE ALSO

L<Lingua::Boolean>

=cut

1;

__END__
