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
#jQuery->document->body
jQuery("div")->find("p")->andSelf()->addClass("border");
    jQuery("div")->find("p")->addClass("background");

    
    print jQuery->as_HTML;




__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>
  p, div { margin:5px; padding:5px; }
  .border { border: 2px solid red; }
  .background { background:yellow; }
  </style>
  <script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
  <div>
    <p>First Paragraph</p>
    <p>Second Paragraph</p>
  </div>
<script>
    

</script>

</body>
</html>