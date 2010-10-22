use strict;
use warnings;
use 5.0100;
use Test::More tests => 4;

use Lingua::Boolean;

my $lang = 'en';

my @languages = Lingua::Boolean::languages();
ok($lang ~~ @languages, "$lang is available");

subtest 'yes' => sub {   #YES
    my @yes = ('y', 'yes', 'ok', 'on', 'Y', 'YES', 'OK', 'ON', 1, 2);
    plan tests => scalar @yes;

    foreach my $word (@yes) {
        ok(boolean($word, $lang), "$word is true");
    }
};

subtest 'no' => sub {   # NO
    my @no = ('n', 'no', 'off', 'not ok', 'N', 'NO', 'OFF', 'NOTOK', 0);
    plan tests => scalar @no;

    foreach my $word (@no) {
        ok(!boolean($word, $lang), "$word is false");
    }
};

subtest 'fail' => sub { # nonsense
    my @nonsense = qw(one two three);
    plan tests => scalar @nonsense;

    foreach my $word (@nonsense) {
        eval {
            boolean($word, $lang);
        };
        like($@, qr{^'$word' isn't recognizable as either true or false}, "$word is nonsense");
    }
};
