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
#jQuery("div:first")->nextAll()->addClass("after");
jQuery("p")->prev(".selected")->css("background", "yellow");
print jQuery->as_HTML;


__DATA__
<!DOCTYPE html>
<html>
<head>

</head>
<body>
  <div><span>Hello</span></div>

  <p class="selected">Hello Again</p>
  <p>And Again</p>
<script></script>

</body>
</html>