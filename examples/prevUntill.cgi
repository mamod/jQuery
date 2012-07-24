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

jQuery("#term-2")->prevUntil("dt")
  ->css("background-color", "red");
  
my $term1 = jQuery->document->getElementById('term-1');

jQuery("#term-3")->prevUntil($term1, "dd")
->css("color", "green");



print jQuery->as_HTML;


__DATA__
<!DOCTYPE html>
<html>
<head>

</head>
<body>
  <dl>
  <dt id="term-1">term 1</dt>
  <dd>definition 1-a</dd>
  <dd>definition 1-b</dd>
  <dd>definition 1-c</dd>
  <dd>definition 1-d</dd>

  <dt id="term-2">term 2</dt>
  <dd>definition 2-a</dd>
  <dd>definition 2-b</dd>
  <dd>definition 2-c</dd>

  <dt id="term-3">term 3</dt>
  <dd>definition 3-a</dd>
  <dd>definition 3-b</dd>
</dl>

</body>
</html>