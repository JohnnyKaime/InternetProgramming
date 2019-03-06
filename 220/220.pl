#! /usr/bin/perl -w

use strict;
use warnings;
use CGI;

my $query = new CGI;
my $cookie = $query->cookie(
	-name=>'Admin',
    -value=>'PerlIsLife',
    -expires=>'+20m',
    -path=>'/');

undef $/;
my $webfile = '220.html';
open( FILE, "< $webfile" ) or die "Could not open $webfile";
my $template = <FILE>;
close( FILE );

print $query->header( -Cache_Control => 'private' );
print $template;

my $password = $query->param( 'password' );
my $username = $query->param( 'username' );
if(defined $username and defined $password){
	print $password;
	print $username;
}

my $theCookie = $query->cookie('Account1');

if ("$theCookie") {
   print "<BLOCKQUOTE>\n";
   print $theCookie;
   print "</BLOCKQUOTE>\n";
} else {
   print "Can't find my cookie!\n";
}
