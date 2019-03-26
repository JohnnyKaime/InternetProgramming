#! /usr/bin/perl                                                  
use strict;
use warnings;
use WWW::Mechanize;

my $filename = "trainer.txt";

open( FILE, "< $filename" ) or die "Could not open $filename";
my %vecHashPos;
my %vecHashExists;
my %rankedHash;

sub vecHashIntalize {
  while ((my $key, my $value) = each (%vecHashExists)){
        $vecHashExists{$key} = -1;
    }
}

my $yes = 0;
my $no  = 0 ;

my $i = 1;
while(my $vector =<FILE>){
    chomp $vector;
    $vecHashPos{$vector} = $i;
    $vecHashExists{$vector} = -1;
    $i++;
}

my $fname = 'urls.txt';
open( FILE, "< $fname" ) or die "Could not open $fname";

my $fileName = 'results.txt';
open(my $fh, '>', $fileName) or die "Could not open file $fileName";

my $mech = WWW::Mechanize->new();

while(my $url =<FILE>){
    my $sum =0;
    vecHashIntalize();
    $mech->get( $url );
    print "$url\n" ;
	
    my $textVec = $mech-> text();
    $textVec =~ s/^\s+|\s+$//g;
    #$textVec =~ s/[^a-zA-Z0-9,]//g;
    $textVec =~ s/[^!-~\s]//g;
    $textVec=~ s/[^a-zA-Z0-9 ]//g;
    $textVec =~ s/\d//g;
    $textVec = lc $textVec;
    
    my @wordsVec = split(/ {1,}/, $textVec);
    my %uniqueUrlHash = ();
    my $i = 1 ;
    
    foreach my $item (@wordsVec){
        $uniqueUrlHash{$item} =$i;
        $i++;
    }
    my @uniqVec = keys %uniqueUrlHash;
    @uniqVec = sort @uniqVec; # sorting the array Alphapitically, this  is the words of the urls

    while ((my $key, my $value) = each (%uniqueUrlHash)) # here iam cheking of the words did exist in our vector
    {   
        print $key,", ";
        if (defined $vecHashPos{$key}){
            $vecHashExists{$key} = 1;
            $sum++; 
        }
    }
    
    $rankedHash{$url} = $sum;
    if ( $sum > 300 ){
        print $fh (1," ");
        $yes++;
    }else{
        print $fh (-1," ");
        $no++;
    }
    for my  $key1 (sort { $vecHashPos{$a} <=> $vecHashPos{$b} } keys %vecHashPos){    
        print $fh ( $vecHashPos{$key1}, ":", $vecHashExists{$key1}," " );
    }
	print $fh "\n";
    print "\n\n";
 }
 print "1: $yes\n";
 print "0: $no\n";