#!/usr/bin/perl

#example source - http://api.jquery.com/parents/
#Example: Example: Find all parent elements of each b.

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use jQuery;
use Data::Dumper;
my $cgi = CGI->new();
my $html = do { local $/; <DATA> };
print $cgi->header();


jQuery->new($html);


my $parentEls = jQuery("b")->parents()->map( sub { 
    return this->tagName; 
})->get()->join(", ");

jQuery("b")->append("<strong>" . $parentEls . "</strong>");

print jQuery->as_HTML;


__DATA__
<!DOCTYPE html>
<html>
<head>
  <style>
  b, span, p, html body {
    padding: .5em;
    border: 1px solid;
  }
  b { color:blue; }
  strong { color:red; }
  </style>
 
</head>
<body>
  <div>
    <p>
      <span>
        <b>My parents are: </b>
      </span>

    </p>
  </div>
<script>


</script>

</body>
</html>