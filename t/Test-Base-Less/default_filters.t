use strict;
use warnings;
use utf8;
use Test::Base::Less;

filters {
    test_trim => [qw/trim/],
};

my ($block) = blocks();
is($block->test_trim, $block->expected_trim);

done_testing;
__END__

===
--- test_trim

xxx


--- expected_trim
xxx
--- test_
