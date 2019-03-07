#! /usr/bin/perl -w

use strict;
use warnings;
use CGI;

my $script = new CGI;
if (!$ENV{'HTTP_COOKIE'}){
	print $script->redirect(-uri => '220.pl');
}

my $access = $script->param( 'Log' );
if(defined $access){
	#my $cookie = $script->cookie(-name=>$username, -expires=>'now');
	my $cookie = $script->cookie(-name=>'Admin', -expires=>'now');
	print $script->redirect(-uri => '220.pl');
}

my @nameArray;
my $position;

my $fileCounter = 'counter.txt';
open(FILE, '<', $fileCounter) or die "Could not open $fileCounter";
$position = <FILE>;
close(FILE);

my $fileName = 'messages.txt';
open(FILE, '<', $fileName) or die "Could not open $fileName";
while(my $row = <FILE>){
	push(@nameArray, $row);
}
close(FILE);

undef $/;
my $webfile = '212.html';
open( FILE, "< $webfile" ) or die "Could not open $webfile";
my $template = <FILE>;
close( FILE );

my $message = $script->param( 'message' );
my $username = $script->param( 'username' );
my $next = $script->param( 'Nex' );
my $previous = $script->param( 'Pre' );

if(defined $username){
	$template =~ s/<dummy>(.*?)<\/dummy>/$message/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$username/s;
	my $concat = $username,">>",$message;
	push(@nameArray,$concat);
	$position = scalar @nameArray;
	open(my $fh, '>>', $fileName) or die "Could not open $fileName";
	print $fh $username,">>",$message,"\n";
	close($fh); 
}elsif(defined $next){
	my @element = split('>>',$nameArray[$position]);
	my $name =  $element[0];
	my $mess = $element[1];
	$template =~ s/<dummy>(.*?)<\/dummy>/$mess/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$name/s;
	$position++;
}elsif(defined $previous){
	my @element = split('>>',$nameArray[$position]);
	my $name =  $element[0];
	my $mess = $element[1];
	$template =~ s/<dummy>(.*?)<\/dummy>/$mess/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$name/s;
	$position--;
}
$position = $position % scalar @nameArray;
open(my $fh, '>', $fileCounter) or die "Could not open $fileCounter";
print $fh $position;
close($fh); 

print $script->header( -Cache_Control => 'private' );
print $template;
