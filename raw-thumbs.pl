#!/usr/bin/perl -w

use strict;
my $pwd  = `pwd`; chomp $pwd;
my $path = $ARGV[0] ? $ARGV[0] : '.';

if(open(my $fh,"find $pwd/$path -type f -print |  ")) {

    while(my $item = <$fh>) {
#	next unless $item =~ m/orf$/i;
	next unless $item =~ m/(dng|orf|rw2)$/i;
	chomp $item;
	my $dir = $item;
	$dir =~ s|^(.*?)/([^/]*)$|$1|;
	system "mkdir  $dir/jfr" unless -d "$dir/jfr";
	my $file_name=$2;
	$file_name =~ s/\.(dng|orf|rw2)$/_jfr.JPG/i;
	my $file = "$dir/jfr/$file_name";
	if(!-e $file || ((-M $item) - (-M $file) <0)) {
	    system "ufraw-batch --overwrite --out-type=jpeg --size=2000 --output=$file  $item ";
	}

    }
}
