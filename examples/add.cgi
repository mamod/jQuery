#!/usr/bin/perl

#   Example: Adds more elements, created on the fly, to the set of matched elements.
# example page http://api.jquery.com/add/

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