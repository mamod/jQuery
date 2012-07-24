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

jQuery("div")->html('<b>Wow!</b> Such excitement...');


jQuery("div b")
->append(jQuery->document->createTextNode("!!!"))
->css("color", "red");


    
print jQuery->as_HTML;




__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>
  div { color:blue; font-size:18px; }
  </style>
  
</head>
<body>
  <div></div>
  <div>ss</div>
  <div></div>
<script>

    

</script>

</body>
</html>