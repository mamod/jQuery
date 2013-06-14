#!perl
use jQuery;
use FindBin qw($Bin);
use Test::More tests => 1;

my $html = do {
    local $/; 
    open my $fh, '<', $Bin . '/html/nextAll.html';
    <$fh>;
};

my $expected = do {
    local $/;
    open my $fh, '<', $Bin . '/expected/nextAll.html';
    <$fh>;
};

jQuery->new($html);

jQuery("div:nth-child(1)")->nextAll('p')->addClass("after");

my $got = jQuery->as_HTML;
is($got,$expected);
