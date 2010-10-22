use strict;
use warnings;
use utf8;
use Test::More 0.75 tests => 4;

BEGIN {
    use_ok('Lingua::Boolean', qw(boolean looks_true looks_false languages langs));
}

can_ok('Lingua::Boolean', qw(boolean looks_true looks_false languages langs));

{   # Language codes
    my @has = langs();
    my @should_have = (
        'en',
        'fr',
    );
    is_deeply(\@has, \@should_have, 'Available language codes OK');
}

{   # Languages names
    my @has = languages();
    my @should_have = (
        'English',
        'Français',
    );
    is_deeply(\@has, \@should_have, 'Available language names OK');
}
