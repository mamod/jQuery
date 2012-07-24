#!/usr/bin/perl

#   Example: A contrived example to show some complex functionality of map method. 
#   You can check the same example at with javascript jQuery at
#   http://api.jquery.com/map/

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use jQuery;
use Data::Dumper;
my $cgi = CGI->new();
my $html = do { local $/; <DATA> };
print $cgi->header();

jQuery->new($html);

jQuery("p")->toggleClass("highlight");

print jQuery->as_HTML;




__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>

  p { margin: 4px; font-size:16px; font-weight:bolder;
      cursor:pointer; }
  .blue { color:blue; }
  .highlight { background:yellow; }
  </style>
</head>
<body>
  <p class="blue">Click to toggle</p>
  <p class="blue highlight">highlight</p>
  <p class="blue">on these</p>
  <p class="blue">paragraphs</p>
<script>
    
</script>

</body>
</html>