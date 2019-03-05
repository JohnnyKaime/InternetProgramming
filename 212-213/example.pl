#! /usr/bin/perl -w

use strict;
use warnings;

use CGI;


undef $/; # do not read line by line, but the entire input at once

my $fname = 'mytemplate.html';
open( FILE, "< $fname" ) or die "Could not open $fname";

my $template = <FILE>;

close( FILE );

my @names = 	(
		'Mr. A',
		'Mr. B',
		'Mr. C',
		'Mr. D',
		'Mr. E',
		);

# get a tag from the file
$template =~ s/<name_list>(.+?)<\/name_list>/<name_list><\/name_list>/s;

my $subst_me = $1;

my $script = new CGI;

my $check = $script->param( 'check' );

my $data='';
if( defined $check ){
	# do something with the web parameter
	# check the parameter
	$template =~ s/\$checked/checked/g;
	foreach my $name ( @names ){
		my $copy = $subst_me;
		# change '$name' in the template to its real value
		$copy =~ s/\$name/$name/;
		$data .= $copy;
	}
}else{
	# don't need to do anything with web parameter
	# therefor uncheck the parameter
	$template =~ s/\$checked//g;
}

# replace the tag with data
$template =~ s/<name_list>(.*?)<\/name_list>/$data/s;

# generate the data that gets sent to the web client
print $script->header( -Cache_Control => 'private' );
print $template;
