#!/usr/bin/perl

#   wrapInner Example

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use jQuery;
use Data::Dumper;
my $cgi = CGI->new();
my $html = do { local $/; <DATA> };
print $cgi->header();

my $dom = jQuery->new($html);
jQuery->new('<b>another</b>');

my $t = $dom->jQuery("body");
$t->wrapInner("<div><div><p><em><b></b></em></p></div></div>");

print $dom->as_HTML;



__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>

  div { border:2px green solid; margin:2px; padding:2px; }
  p { background:yellow; margin:2px; padding:2px; }
  </style>
</head>
<body>
  Plain old text, or is it?
<script></script>

</body>
</html>