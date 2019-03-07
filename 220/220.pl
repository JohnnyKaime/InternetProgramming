#! /usr/bin/perl -w

use strict;
use warnings;
use CGI;

my $newCookie;
my $query = new CGI;
my $testCookie = $query->cookie(
	-name=>'Admin',
    -value=>'PerlIsLife',
    -expires=>'+1m',
    -path=>'/');


undef $/;
my $webfile = '220.html';
open( FILE, "< $webfile" ) or die "Could not open $webfile";
my $template = <FILE>;
close( FILE );

my $password = $query->param( 'password' );
my $username = $query->param( 'username' );
if(defined $username and defined $password){
	$newCookie = $query->cookie(
		-name=>$username,
		-value=>$password,
		-expires=>'+30s',
		-path=>'/'
	);
	print $query->redirect(-uri => '212.pl', -cookie => $testCookie);
}

print $query->header( -Cache_Control => 'private', -Cookie=>$testCookie);
print $template;

#my $check = $query->param( 'check' );
#if(defined $check){
	#my $theCookie = $query->cookie($check);
	#if($theCookie){
		#print $theCookie;
	#}else{
		#print "WHERES MY COOKIE";
	#}
#}
