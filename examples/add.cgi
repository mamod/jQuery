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
jQuery("p")->clone()->add("<span>Again</span>")->appendTo(jQuery->document->body)->css('color','red');

    
    print jQuery->as_HTML;




__DATA__
<!DOCTYPE html>
<!DOCTYPE html>
<html>
<head>
  <script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
  <p>Hello</p>
<script></script>

</body>
</html>

</body>
</html>