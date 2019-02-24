#!/usr/bin/perl

use strict;
use warnings;

my $totalMarks;
my $currentTot;
my $studentTotalMarks;
my $fileName = "marks.text";

sub extract{
	my ($rowData) = @_;
	my @rowData = (split /\s+/, $rowData);
	my $progress = 16;
	foreach my $data(@rowData[3..$#rowData]){
		if($data =~ /\((.*?)\)/){
			$totalMarks += $1;
			if($progress != 0){
				$currentTot += $1;
				$progress--;
			}
		}
	}
	print "Std No.\tInit\tSurame\t\t-> (TOT) ",$totalMarks,"\tCurrent % out of ",$currentTot,"\tOverall % out of ",$totalMarks,"\n";
}

open(FILE,"<",$fileName) or die "Can't find marks.txt\n";
#Skip first junk
<FILE>;
my $row = <FILE>;
#Extract 2nd line marks and total
extract($row);
#Remaining student marks
my @rowArr;
$row = <FILE>;
while($row !~ /#/ && $row !~/^$/){
	@rowArr = (split /\s+/, $row);
	
	my $studentMarks;
	my $studentNumber = $rowArr[0];
	my $studentName = $rowArr[1]. "\t".$rowArr[2];
	
	foreach my $marks (@rowArr[3..$#rowArr]){
		if ($marks =~ /^\d+$/){
			$studentMarks += $marks;
			$studentTotalMarks += $marks;
		}
	}
	if ($studentName =~ /Niyonsaba/){
		print $studentNumber," -> ",$studentName,"\t-> ",$studentMarks,"\t\t";
		print sprintf("%.2f",($studentMarks/$currentTot*100)),"\t\t\t",sprintf("%.2f",($studentMarks/$totalMarks*100)),"\n";
	}else{
		print $studentNumber," -> ",$studentName,"\t\t-> ",$studentMarks,"\t\t";
		print sprintf("%.2f",($studentMarks/$currentTot*100)),"\t\t\t",sprintf("%.2f",($studentMarks/$totalMarks*100)),"\n";
	}	
	$row = <FILE>;
}

#system("pause");
