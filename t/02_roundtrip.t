use strict;
use Test::More 0.88;
use TOC::Time::Duration::Parse;

eval { require Time::Duration };
if ($@) {
    plan skip_all => 'Time::Duration is required';
}
$Time::Duration::MILLISECOND = "true";
plan tests => 2000;

my @tests = map int rand(100_000), 1 .. 1000;

for my $test (@tests) {
    my $spec = Time::Duration::duration_exact($test);

    $test = $test * 1000 * 1000;
    is parse_duration($spec), $test, "$spec - $test";
}

for my $test (@tests) {
    my $spec = Time::Duration::concise( Time::Duration::duration_exact($test) );

    $test = $test * 1000 * 1000;
    is parse_duration($spec), $test, "$spec - $test";
}

