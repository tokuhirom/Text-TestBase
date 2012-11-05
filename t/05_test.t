use strict;
use warnings;
use utf8;
use Test::Base::Less;

filters {
    code => [qw/eval/],
};

is_deeply([blocks]->[0]->code, +{ a => 'b' });
is(scalar([blocks]->[1]->code), 'X');
is_deeply([[blocks]->[1]->code], [qw/X Y/]);

done_testing;
__DATA__

===
--- code: +{ a => 'b' }

===
--- code
(
    'X' => 'Y'
)
