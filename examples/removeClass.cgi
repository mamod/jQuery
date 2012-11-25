#!/usr/bin/perl

#   Example: Remove the class 'blue' and 'under' from the matched elements.
# page URL http://api.jquery.com/removeClass/

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use jQuery;
use Data::Dumper;
my $cgi = CGI->new();
my $html = do { local $/; <DATA> };
print $cgi->header();

my $dom = jQuery->new($html);
jQuery->new('<b>new</b>');
 
$dom->jQuery($dom->jQuery("p:odd"))->removeClass(sub {
  return 'blue under';
})->css('color','pink');


print $dom->as_HTML;




__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>

  p { margin: 4px; font-size:16px; font-weight:bolder; }
  .blue { color:blue; }
  .under { text-decoration:underline; }
  .highlight { background:yellow; }
  </style>
  <script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
  <p class="blue under">Hello</p>
  <p class="blue under highlight">and</p>
  <p class="blue under">then</p>

  <p class="blue under">Goodbye</p>

</body>
</html>