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
#jQuery("div:first")->nextAll()->addClass("after");
jQuery(":nth-child(1)")->nextAll("p")->addClass("after");
print jQuery->as_HTML;


__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>
  div, p { width: 60px; height: 60px; background: #abc;
           border: 2px solid black; margin: 10px; float: left; }
  .after { border-color: red; }
  </style>
  
</head>
<body>
  <p>p</p>

  <div>div</div>
  <p>p</p>
  <p>p</p>
  <div>div</div>

  <p>p</p>
  <div>div</div>
<script>
    
</script>

</body>
</html>