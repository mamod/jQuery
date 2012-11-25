#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use jQuery;
use Data::Dumper;
my $cgi = CGI->new();
my $html = do { local $/; <DATA> };
print $cgi->header();

jQuery->new($html);
my $b;
 my $t = $b;
 print 'ggg' if defined $t;

#print jQuery("p:first")->hasClass('selected');
jQuery("div#result1")->append(jQuery("p:first")->hasClass("selected"));
jQuery("div#result2")->append(jQuery("p:last")->hasClass("selected"));
jQuery("div#result3")->append(jQuery("p")->hasClass("selected"));


    
print jQuery->as_HTML;




__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>
  p { margin: 8px; font-size:16px; }
  .selected { color:red; }
  </style>
</head>
<body>
  
  <p class="nn">This paragraph is black and is the first paragraph.</p>
  <p class="selected">This paragraph is red and is the second paragraph.</p>

  <div id="result1">First paragraph has selected class: </div>
  <div id="result2">Second paragraph has selected class: </div>
  <div id="result3">At least one paragraph has selected class: </div>


</body>
</html>