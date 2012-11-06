use strict;
use warnings;
use utf8;
use Test::More;
use Data::Section::TestBase;

my @blocks = blocks;

is(0+@blocks, 2);

subtest 'first block' => sub {
    my $b = $blocks[0];
    is($b->name, 'foo');
    is($b->get_section('input'), 'yyy');
    is($b->get_section('expected'), 'zzz');
    is($b->get_lineno, 31, 'lineno');
};

subtest 'second block' => sub {
    my $b = $blocks[1];
    is($b->name, 'bar');
    is($b->get_section('input'), "xxx\n");
    is($b->get_section('expected'), "ppp\n");
    is($b->get_lineno, 35, 'lineno');
};

done_testing;

__DATA__

=== foo
--- input: yyy
--- expected: zzz

=== bar
--- input
xxx
--- expected
ppp
