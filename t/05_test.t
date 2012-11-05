use strict;
use warnings;
use utf8;
use Test::Base::Less;

filters {
    code => [qw/eval/],
};

is_deeply([blocks]->[0]->code, +{ a => 'b' });

done_testing;
__DATA__

===
--- code: +{ a => 'b' }

