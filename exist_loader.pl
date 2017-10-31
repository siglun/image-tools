#!/usr/bin/perl -w

#
# A script that can be used loading and deleting files in an exist database.
# $Revision: 1.4 $ last modified $Date: 2011/08/29 12:42:29 $ by $Author: slu $
#

use strict;
use LWP::UserAgent;
use Getopt::Long;

my $file_list = "";
my $scheme    = "http://";
my $host_port = "localhost:8080";
my $context   = "/exist/rest/db/";
my $target    = "";
my $user      = "";
my $password  = "";
my $load      = '';
my $delete    = '';
my $get       = '';
my $suffix    = '';

# http://kb-cop.kb.dk:8080/exist/index.xml
# admin password florsocker

my $result = GetOptions (
    "context=s"     => \$context,
    "delete=s"      => \$delete,
    "file-list=s"   => \$file_list,
    "get=s"         => \$get,
    "host-port=s"   => \$host_port,
    "load=s"        => \$load,
    "password=s"    => \$password,
    "suffix=s"      => \$suffix,
    "target=s"      => \$target,
    "user=s"        => \$user,
);

my $source = "";
if($load) {
    $source = $load;
} elsif($delete) {
    $source = $delete;
} elsif($get) {
    $source = $get;
} elsif($file_list) {
} else {
    &usage();
}

my %suffixes = ('xml' => 'text/xml',
		'xq'  => 'application/xquery');

my $file_name = "";

if($suffix) {
    $file_name = " -name '*".$suffix."'";
}

my $files  = "";

if($load) {
    $files = "/usr/bin/find $source -type f $file_name -print |";
} else {
    $files = $file_list;
}

if(open FILES,$files) {
    
    my $ua = LWP::UserAgent->new;
    $ua->agent("crud-client/0.1 ");
    $ua->credentials($host_port, "exist" , $user, $password );

    while(my $file = <FILES>) {

	chomp $file;
	print STDERR "$file\n";

	my $content = "";
	if (open CONTENT,"<$file") {
	    while(my $line = <CONTENT>) {
		$content .= $line;
	    }
	    close CONTENT;
	}

	my $localcopy = $file;
	$file =~ s/$source/$target/;
	my $req_uri = $scheme . $host_port . $context . $file;
	print STDERR $req_uri . "\n";

# Create a request

	my $req = new HTTP::Request();
	$req->uri($req_uri);
	if($load) {
	    $req->method("PUT");
	    $req->content($content);
	} elsif($delete) {
	    $req->method("DELETE");
	} else {
	    $req->method("GET");
	}
	$req->header( "Content-Type" => $suffixes{$suffix} );

# Pass request to the user agent and get a response back
	my $res = $ua->request($req);

## Check the outcome of the response
	if ($res->is_success) {
	    print STDERR "Success ", $res->status_line, "\n";
	    if($get) {
		if (open CONTENT,">$localcopy") {
		    print CONTENT $res->content();
		}
	    }
	} else {
	    print STDERR "Failure ", $res->status_line, "\n";
	}

    }
}

sub usage {

    print <<"END";
Correct usage:
$0 <options>
where options are
   --load <directory> 
        from where to read files for loading
   --file-list <file name>
        the name of a file containing a list names of xml files to be stored.
   --get <directory>
        where to write retrieved files
   --delete <directory with a backup>
        the files in that are found in the directory will be deleted from the
        database if there exist files with the same name

    --suffix <suffix> 
        file suffix to look for in the load directory. for example xml

    --target <target name>
        Basically database name. Default is $target

    --context <context>
        Root for the rest services. Default is $context

    --user <user name>
    --password <password of user>
    --host-port <host and port for server>
        Default is localhost:8080

For example

$0 \
      --host-port kb-cop.kb.dk:8080  \\
      --suffix xml \\
      --load ../../mei_editor_test/data/ \\
      --context $context \\
      --target $target

will load the xml-files in directory ../../mei_editor_test/data/ into a
database with base URI

http://kb-cop.kb.dk:8080/exist/rest/db/dcm-catalog/

END

}

#
# $Log: load_exist.pl,v $
# Revision 1.4  2011/08/29 12:42:29  slu
# OK
#
# Revision 1.3  2011/05/12 07:54:23  slu
# added RCS macron
#
#

#./load_exist.pl --host-port kb-cop.kb.dk:8080 --suffix xml --load ../../mei_editor_test/data/  --context /exist/rest/db/ --target dcm-catalog/

