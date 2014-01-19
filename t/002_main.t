# -*- perl -*-

use Test::More tests => 6;

use FindBin;
use lib $FindBin::Bin. '/../lib/';
use Format::LongNumber;

my $seconds = 123;
is short_time($seconds), '2.05 m', 'short_time()';
is full_time($seconds), '2 m 3 s', 'full_time()';

my $bytes = 1125;
is short_traffic($bytes), '1.10K', 'short_traffic()';
is full_traffic($bytes), '1K 101 Bytes', 'full_traffic()';

my $number = 10001;
is short_number($number), '10.00K', 'short_number()';
is full_number($number), '10K 1', 'full_number()';
