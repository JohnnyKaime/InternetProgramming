#! /usr/bin/perl -w

use strict;
use warnings;
use CGI;

my %messageHash;
my @nameArray;
my $position;

my $fileName = 'messages.txt';
open(my $fh, '+<', $fileName) or die "Could not open $fileName";

while(my $row = <$fh>){
	my @row = split('>>',$row);
	$messageHash{$row[0]} = $row[1];
	push(@nameArray, $row[0]);
}
close($fh); 

undef $/;
my $webfile = '212.html';
open( FILE, "< $webfile" ) or die "Could not open $webfile";
my $template = <FILE>;
close( FILE );

my $script = new CGI;

my $message = $script->param( 'message' );
my $username = $script->param( 'username' );
my $next = $script->param( 'Nex' );
my $previous = $script->param( 'Pre' );


if(defined $username){
	$template =~ s/<dummy>(.*?)<\/dummy>/$message/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$username/s;
	$messageHash{$username} = $message;
	push(@nameArray,$username);
	$position = scalar @nameArray;
}elsif(defined $next){
	my $name = $nameArray[$position];
	my $mess = $messageHash{$nameArray[$position]};
	$template =~ s/<dummy>(.*?)<\/dummy>/$mess/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$name/s;
	$position++;
}elsif(defined $previous){
	my $name = $nameArray[$position];
	my $mess = $messageHash{$nameArray[$position]};
	$template =~ s/<dummy>(.*?)<\/dummy>/$mess/s;
	$template =~ s/{dumName}(.*?){\/dumName}/$name/s;
	$position--;
}

open(my $fh, '>', $fileName) or die "Could not open $fileName";
foreach my $key (keys %messageHash){
	print $fh $key,">>",$messageHash{$key},"\n";
}
close($fh); 

print $script->header( -Cache_Control => 'private' );
print $template;
