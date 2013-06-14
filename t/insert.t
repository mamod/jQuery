#!perl
use jQuery;
use FindBin qw($Bin);
use Test::More tests => 1;

my $html = do {
    local $/; 
    open my $fh, '<', $Bin . '/html/insert.html';
    <$fh>;
};

my $expected = do {
    local $/;
    open my $fh, '<', $Bin . '/expected/insert.html';
    <$fh>;
};

jQuery->new($html);

jQuery("#single")->val("Single2");
jQuery("#multiple")->val(["Multiple2", "Multiple3"]); 
jQuery("input")->val(["check1","check2", "radio1" ]);

my $got = jQuery->as_HTML;
is($got,$expected);
