package Lingua::Boolean::English;
# ABSTRACT: DEPRECATED - provides English rules to Lingua::Boolean
use strict;
use warnings;
use utf8;
# VERSION

=head1 DESCRIPTION

This module provides rules for English to C<Lingua::Boolean>.

=cut

=head1 METHODS

=head2 new

C<new()> creates a new C<Lingua::Boolean::English> object. This is
intended for consumption by L<Lingua::Boolean> only.

=cut

sub new {
    my $class = shift;

    my $LANG = 'en';
    my $LANGUAGE = 'English';

    my $match;
    $match->{True}  = [qr{^y(?:es)?$}i, qr{^on$}i, qr{^ok$}i, qr{^true$}i, qr{^[1-9]$}];
    $match->{False} = [qr{^no?$}i, qr{^off$}i, qr{not ?ok$}i, qr{^false$}i, qr{^0$}];

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
