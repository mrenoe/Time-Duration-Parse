use strict;
use Test::More 0.88;

use TOC::Time::Duration::Parse;

my @GOOD_TIME_SPECS = (
    [ '3ms',           3000 ],
    [ '4milliseconds', 4000 ],
    [ '5millisecond',  5000 ],
    [ '5msecs',        5000 ],

    [ '3',                       3000000 ],
    [ '3 seconds',               3000000 ],
    [ '3 Seconds',               3000000 ],
    [ '3 s',                     3000000 ],
    [ '6 minutes',               360000000 ],
    [ '6 minutes and 3 seconds', 363000000 ],
    [ '6 Minutes and 3 seconds', 363000000 ],
    [ '1 day',                   86400000000 ],
    [ '1 day, and 3 seconds',    86403000000 ],
    [ '-1 seconds',              -1000000 ],
    [ '-6 minutes',              -360000000 ],

    [ '1 hr',  3600000000 ],
    [ '3s',    3000000 ],
    [ '1hr',   3600000000 ],
    [ '+2h',   7200000000 ],
    [ '1hrs',  3600000000 ],
    [ '+2hrs', 7200000000 ],

    [ '1d 2:03',    93780000000 ],
    [ '1d 2:03:01', 93781000000 ],
    [ '1d -24:00',  0 ],
    [ '2:03',       7380000000 ],
    [ '2:03:00',    7380000000 ],
    [ '2:03:00.1',  7380100000 ],
    [ '2:03:00.8',  7380800000 ],

    [ ' 1s   ', 1000000 ],
    [ '   1  ', 1000000 ],
    [ '  1.3 ', 1300000 ],

    [ '1.5h',     5400000000 ],
    [ '1,5h',     5400000000 ],
    [ '1.5h 30m', 7200000000 ],
    [ '1.9s',     1900000 ],      # Check rounding
    [ '1.3s',     1300000 ],
    [ '1.3',      1300000 ],
    [ '1.9',      1900000 ],

    [ '1h,30m, 3s',    5403000000 ],
    [ '1h and 30m,3s', 5403000000 ],
    [ '1,5h, 3s',      5403000000 ],
    [ '1,5h and 3s',   5403000000 ],
    [ '1.5h, 3s',      5403000000 ],
    [ '1.5h and 3s',   5403000000 ],

    [ '450 hrs',                    1620000000000 ],
    [ '170 hrs 35 mins 21 seconds', 614121000000 ],

    [ '1 month',  2592000000000 ],
    [ '2 months', 5184000000000 ],
    [ '2 mo',     5184000000000 ],
    [ '2 mon',    5184000000000 ],
    [ '2 mons',   5184000000000 ],
);

my @BAD_TIME_SPECS =
  ( '3 sss', '6 minutes and 3 sss', '6 minutes, and 3 seconds a', );

plan tests => int(@GOOD_TIME_SPECS) + int(@BAD_TIME_SPECS);

foreach my $test (@GOOD_TIME_SPECS) {
    my ( $spec, $expected_seconds ) = @$test;
    ok_duration( $spec, $expected_seconds );
}

foreach my $spec (@BAD_TIME_SPECS) {
    fail_duration($spec);
}

sub ok_duration {
    my ( $spec, $seconds ) = @_;
    is parse_duration($spec), $seconds, "$spec = $seconds";
}

sub fail_duration {
    my $spec = shift;
    eval { parse_duration($spec) };
    ok $@, $@;
}
