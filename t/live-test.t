#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 13;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# 1 make sure testapp works
use_ok 'TestApp';

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;

# 2-4
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'see if it has our text');
is $mech->response->headers->{'content-type'}, 'text/html; charset=utf-8',
  'No Accept header = text/html';
  
$mech->add_header( Accept => 'text/html' );

# 5-7
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'see if it has our text');
is $mech->response->headers->{'content-type'}, 'text/html; charset=utf-8',
  'Accept header of text/html = text/html';

$mech->add_header( Accept => 'application/xhtml+xml' );

# 8-10
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'see if it has our text');
is $mech->response->headers->{'content-type'}, 'application/xhtml+xml; charset=utf-8',
  'Accept xhtml gives content type application/xhtml+xml';

# 11-13
$mech->get_ok('http://localhost/nothtml', 'get nothtml page');
$mech->content_like(qr/not html/i, 'see if it has our text');
is $mech->response->headers->{'content-type'}, 'application/json',
  'application/json is unmolested';
