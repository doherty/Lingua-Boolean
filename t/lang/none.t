use strict;
use warnings;
use 5.0100;
use Test::More 0.94 tests => 3;

use Lingua::Boolean;

subtest 'yes' => sub {   #YES
    my @yes = (' y', 'yes ', 'ok', 'on', 'Y', 'YES', 'OK', 'ON', 1, 2);
    plan tests => scalar @yes * 2;
    foreach my $word (@yes) {
        ok(boolean($word), "$word is true");
        is(boolean($word), boolean($word, 'en'), q{Default 'en' applied OK});
    }
};

subtest 'no' => sub {   # NO
    my @no = ('n ', ' no', 'off', 'not ok', 'N', 'NO', 'OFF', 'NOTOK', 0);
    plan tests => scalar @no * 2;
    foreach my $word (@no) {
        ok(!boolean($word), "$word is false");
        is(boolean($word), boolean($word, 'en'), q{Default 'en' applied OK});
    }
};

subtest 'fail' => sub { # nonsense
    my @nonsense = qw(one two three);
    plan tests => scalar @nonsense;
    foreach my $word (@nonsense) {
        eval {
            boolean($word);
        };
        like($@, qr{^'$word' isn't recognizable as either true or false}, "$word is nonsense");
    }
};
