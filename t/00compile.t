use strict;
use warnings;
use Test::More tests => 58;

BEGIN {
    use_ok('Net::SinaWeibo');
}
foreach my $m (keys %Net::SinaWeibo::SINA_API) {
    ok(Net::SinaWeibo->can($m),"compile api:$m");
}


