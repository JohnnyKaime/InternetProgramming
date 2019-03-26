#! /usr/bin/perl -w
use strict;
use warnings;
use WWW::Mechanize;

my $urlVec = "https://myanimelist.net/anime/1575/Code_Geass__Hangyaku_no_Lelouch";

my $mech = WWW::Mechanize->new();
$mech->get( $urlVec );
my $textVec = $mech-> text();
$textVec =~ s/^\s+|\s+$//g;
$textVec =~ s/[^!-~\s]//g;
$textVec=~ s/[^a-zA-Z0-9 ]//g;
$textVec =~ s/\d//g;
$textVec = lc $textVec;
my @wordsVec = split(/ {1,}/, $textVec);

my %unique = ();
foreach my $item (@wordsVec){
    $unique{$item} = 1;    
}
my @uniqVec = keys %unique;
@uniqVec = sort @uniqVec;

my $filename = 'fileVec.txt';
open(my $fh, '>', $filename) or die "Could not open file $filename";
foreach my $word (@uniqVec ){
    print  $fh ($word,"\n") ;
}