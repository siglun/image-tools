#!/usr/bin/perl -w

use strict;

my $tool = "exiftool -X ";

if (open(my $find,'find '.$ARGV[0].' -type f -print |')) {

    while(my $img = <$find>) {
	chomp $img;
	if($img =~ m{(orf|png|arw|rw2|tif|tiff|dng|jpg|jpeg)$}i) {
	    next unless -f $img;
	    next if $img =~ m|\/jfr\/|;
	    my $file = $img . '.xml';
	    if(!-e $file || ((-M $img) - (-M $file) <0)) {
		print STDERR "Reading from $img, writing to $file\n";
		system "$tool $img > $file";
	    }
	}

    }

}
 
