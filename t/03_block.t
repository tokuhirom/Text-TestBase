use strict;
use warnings;
use utf8;
use Test::More;
use Text::TestBase;
use Data::Dumper;

my $hunk = <<'...';
=== hogehoge
--- ONLY
--- input
xxx
--- expected
yyy
...

my $block = Text::TestBase->new()->_make_block($hunk);
subtest 'check' => sub {
    is($block->get_section('input'), "xxx\n");
    is($block->input, "xxx\n");
    is($block->get_section('expected'), "yyy\n");
    is($block->description, "hogehoge");
    is($block->name, "hogehoge");
    ok($block->has_section('ONLY'));
    ok(not $block->has_section('SKIP'));
};
note Dumper($block);

done_testing;
