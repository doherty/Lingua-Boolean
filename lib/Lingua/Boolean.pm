use strict;
use warnings;
use 5.0100;

package Lingua::Boolean;
# ABSTRACT: comprehensively parse boolean response strings

use Carp;
use boolean 0.21 qw(true false);

=head1 SYNOPSIS

    use Lingua::Boolean;
    print "Do it? ";
    chomp(my $response = <>);
    if ( boolean $response ) {   # YES, y, OK, 1...
        print "OK, doing it.\n";
    }
    else {                      # no, N, 0...
        print "OK, not doing it.\n";
    }

    # Once more, with feeling
    print "Fait-le? ";
    chomp(my $response = <>);
    if ( boolean $response, 'fr' ) {    # OUI
        print "OK, on le fait.\n";
    }
    else {                              # non
        print "OK, on ne le fait pas.\n";
    }

=head1 DESCRIPTION

Does that string look like they said "true" or "false"? To know, you
have to check a lot of things. L<Lingua::Boolean> attempts to do that
in a single module, and do so for multiple languages.

=head1 FUNCTIONS

=head2 import

Calling C<import()> will, obviously, import subs into your namespace.
By default, L<Lingua::Boolean> imports the sub C<boolean()>. You can
request to have C<looks_true()>, C<looks_false()>, and C<languages()>
imported.

=cut

use Exporter qw(import);
our @EXPORT    = qw(boolean); # EXPORTS
our @EXPORT_OK = qw(looks_true looks_false languages);

my $langs; # PATCHES WELCOME
$langs->{en}->{yes} = [qr{^y(?:es)?$}i, qr{^on$}i, qr{^ok$}i, qr{^[1-9]$}];
$langs->{en}->{no}  = [qr{^no?$}i, qr{^off$}i, qr{not ?ok$}i, qr{^0$}];

$langs->{fr}->{yes} = [qr{^oui$}i, qr{^ok$}i, qr{^[1-9]$}];
$langs->{fr}->{no}  = [qr{^n(?:on?)?$}i, qr{^0$}];

=head2 languages

C<languages()> returns the list of languages L<Lingua::Boolean> knows about.

=cut

sub languages {
    return keys %$langs;
}

=head2 looks_true

C<looks_true()> tells you whether L<Lingua::Boolean> thinks the thing looks
true. By default, it uses I<en>; pass a language code as the second parameter
to check another language. Croaks if the language is unknown to L<Lingua::Boolean>.

=cut

sub looks_true {
    my $to_test = shift;
    my $lang    = shift || 'en';

    croak "I don't know anything about the language '$lang'" unless exists $langs->{$lang};
    return true if ($to_test ~~ $langs->{$lang}->{yes});
    return false;
}

=head2 looks_false

C<looks_false()> tells you whether L<Lingua::Boolean> thinks the thing looks
false. By default, it uses I<en>; pass a language code as the second parameter
to check another language. Croaks if the language is unknown to L<Lingua::Boolean>.

=cut

sub looks_false {
    my $to_test = shift;
    my $lang    = shift || 'en';

    croak "I don't know anything about the language '$lang'" unless exists $langs->{$lang};
    return true if ($to_test ~~ $langs->{$lang}->{no});
    return false;
}

=head2 B<boolean>

B<C<boolean()>> tries to determine if the string C<looks_true()> or C<looks_false()>, and
returns true or false accordingly. If both tests fail, dies. By default, uses I<en>; pass
a language code as the second parameter to check another language. Croaks if the language
is unknown to L<Lingua::Boolean>.

=cut

sub boolean {
    my $to_test = shift;
    my $lang    = shift || 'en';

    if (looks_true($to_test, $lang)) {
        return true;
    }
    elsif (looks_false($to_test, $lang)) {
        return false;
    }
    else {
        #omg
        die "'$to_test' isn't recognizable as either true or false";
    }
}

=head1 EXPORTS

By default, L<Lingua::Boolean> exports C<boolean()>.

=cut

1;

__END__
