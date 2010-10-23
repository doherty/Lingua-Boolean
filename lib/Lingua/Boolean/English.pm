use strict;
use warnings;
use utf8;
package Lingua::Boolean::English;
# ABSTRACT: provides English to Lingua::Boolean

our $LANG = 'en';
our $LANGUAGE = 'English';

our $match;
$match->{True}  = [qr{^y(?:es)?$}i, qr{^on$}i, qr{^ok$}i, qr{^true$}i, qr{^[1-9]$}];
$match->{False} = [qr{^no?$}i, qr{^off$}i, qr{not ?ok$}i, qr{^false$}i, qr{^0$}];

1;

__END__
