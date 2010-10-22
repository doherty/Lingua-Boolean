use strict;
use warnings;
use Test::More 0.94 tests => 3;

use Lingua::Boolean;

my $lang = 'nonexistent';

my @languages = Lingua::Boolean::languages();
ok(!($lang ~~ @languages), "$lang isn't available");

subtest 'yes' => sub {   #YES
    my @yes = ('y', 'yes', 'ok', 'on', 'Y', 'YES', 'OK', 'ON', 1, 2);
    plan tests => scalar @yes;

    foreach my $word (@yes) {
        eval {
            boolean($word, $lang);
        };
        like($@, qr{^I don't know anything about the language '$lang'}o, 'failed OK');
    }
};

subtest 'no' => sub {   # NO
    my @no = ('n', 'no', 'off', 'not ok', 'N', 'NO', 'OFF', 'NOTOK', 0);
    plan tests => scalar @no;

    foreach my $word (@no) {
        eval {
            boolean($word, $lang);
        };
        like($@, qr{^I don't know anything about the language '$lang'}o, 'failed OK');
    }
};
