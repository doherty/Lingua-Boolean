use strict;
use warnings;
# use diagnostics;
# use Data::Dumper;
use 5.0100;

package Lingua::Boolean;
# ABSTRACT: comprehensively parse boolean response strings

use Carp;
use boolean 0.21 qw(true false);

=head1 SYNOPSIS

    use Lingua::Boolean;

    # Use functional/procedural interface
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
    chomp($response = <>);
    if ( boolean $response, 'fr' ) {    # OUI
        print "OK, on le fait.\n";
    }
    else {                              # non
        print "OK, on ne le fait pas.\n";
    }

    # Or, use OO interface
    my $bool = Lingua::Boolean->new('en');
    print "Do it? ";
    chomp($response = <>);
    if ($bool->boolean($response)) {
        print "OK, doing it!\n";
    }
    else {
        print "OK, not doing it.\n";
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
our @EXPORT = qw(boolean);

=head1 METHODS

=head2 new

C<new()> creates a new C<Lingua::Boolean> object. You can optionally give it
the code for the language you'll be working with, and only that language will
be loaded. If you do so, you needn't pass the language to every call to
C<boolean()>:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new('fr');
    print ($bool->boolean('oui') ? "TRUE\n" : "FALSE\n");

Otherwise, C<boolean()> accept the language code as the second parameter:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new();
    print ($bool->boolean('oui', 'fr') ? "TRUE\n" : "FALSE\n");

=cut

sub new {
    my $class = shift;
    my $lang  = shift;

    use Module::Pluggable search_path => [__PACKAGE__], require => 1;

    my $regexes;
    my $languages;
    BUILD: foreach my $plugin ( __PACKAGE__->plugins() ) {
        my $obj = $plugin->new();
        next BUILD if (defined $lang and $obj->{LANG} ne $lang);

        $regexes->{ $obj->{LANG} } = $obj->{match};
        $languages->{ $obj->{LANG} } = $obj->{LANGUAGE};
    }

    my $self = {
        regexes => $regexes,
        languages => $languages,
        lang => $lang,
    };
    bless $self, $class;
    return $self;
}

=head2 languages

C<languages()> returns the list of languages L<Lingua::Boolean> knows about.

    use Lingua::Boolean;
    my @languages = Lingua::Boolean::languages(); # qw(English Français ...)

When called as an object method, returns the languages B<that object> knows
about:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new('fr');
    my @languages = $bool->languages(); # qw(Français)

=cut

sub languages {
    my $self = ref $_[0] eq __PACKAGE__ ? shift : __PACKAGE__->new();

    my @long_names;
    foreach my $l (keys %{ $self->{languages} }) {
        push @long_names, $self->{languages}->{$l};
    }
    return @long_names;
}

=head2 langs

C<langs()> returns the list of language codes L<Lingua::Boolean> knows about.

    use Lingua::Boolean;
    my @lang_codes = Lingua::Boolean::langs(); # qw(en fr ...)

When called as an object method, returns the languages B<that object> knows
about:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new('fr');
    my @lang_codes = $bool->langs(); # qw(fr)

=cut

sub langs {
    my $self = ref $_[0] eq __PACKAGE__ ? shift : __PACKAGE__->new();

    my @lang_codes = keys %{ $self->{languages} };
    return @lang_codes;
}

=head2 B<boolean>

B<C<boolean()>> tries to determine if the string I<looks> true or I<looks> false, and
returns true or false accordingly. If both tests fail, dies. By default, uses I<en>; pass
a language code as the second parameter to check another language. Croaks if the language
is unknown to Lingua::Boolean (or the Lingua::Boolean object, if used as an object method).

This sub is exported by default, and can be used functionally:

    use Lingua::Boolean;
    print (boolean('yes') ? "TRUE\n" : "FALSE\n");

Or, if you prefer object orientation, C<boolean()> is also an object method:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new();
    print ($bool->boolean('yes') ? "TRUE\n" : "FALSE\n");

If you specify the language in the constructor, you needn't specify it in the call to C<boolean()>:

    use Lingua::Boolean qw();
    my $bool = Lingua::Boolean->new('fr');
    print ($bool->boolean('OUI') ? "TRUE\n" : "FALSE\n");

=cut

sub _boolean {
    my $self    = shift;
    my $to_test = shift;
    my $lang    = shift || 'en';
    _trim($to_test);

    if ($self->_looks_true($to_test, $lang)) {
        return true;
    }
    elsif ($self->_looks_false($to_test, $lang)) {
        return false;
    }
    else {
        croak "'$to_test' isn't recognizable as either true or false";
    }
}

sub boolean {
    my $self    = ref $_[0] eq __PACKAGE__ ? shift : __PACKAGE__->new($_[1]);
    my $to_test = shift;
    my $lang    = shift || $self->{lang};
    _trim($to_test);

    return $self->_boolean($to_test, $lang);
}

=head1 EXPORTS

By default, L<Lingua::Boolean> exports C<boolean()>. All other methods
must be fully qualified - or use the object oriented interface.

=cut

sub _looks_true {
    my $self    = shift;
    my $to_test = shift;
    my $lang    = shift || 'en';
    _trim($to_test);

    croak "I don't know anything about the language '$lang'" unless exists $self->{regexes}->{$lang}->{True};
    return true if ($to_test ~~ $self->{regexes}->{$lang}->{True});
    return false;
}

sub _looks_false {
    my $self    = shift;
    my $to_test = shift;
    my $lang    = shift || 'en';
    _trim($to_test);

    croak "I don't know anything about the language '$lang'" unless exists $self->{regexes}->{$lang}->{False};
    return true if ($to_test ~~ $self->{regexes}->{$lang}->{False});
    return false;
}

sub _trim { # http://www.perlmonks.org/?node_id=36684
    @_ = $_ if not @_ and defined wantarray;
    @_ = @_ if defined wantarray;
    for (@_ ? @_ : $_) { s/^\s+|\s+$//g }
    return wantarray ? @_ : $_[0] if defined wantarray;
}

1;

__END__
