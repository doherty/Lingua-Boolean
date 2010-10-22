use strict;
use warnings;
use Test::More 0.75 tests => 2;

BEGIN {
    use_ok('Lingua::Boolean', qw(boolean looks_true looks_false languages));
}

can_ok('Lingua::Boolean', qw(boolean looks_true looks_false languages));
