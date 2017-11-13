xquery version "3.0" encoding "UTF-8";

declare namespace local="http://this-app";
declare namespace util="http://exist-db.org/xquery/util";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace sys="http://ns.exiftool.ca/File/System/1.0/";
declare namespace f="http://ns.exiftool.ca/File/1.0/";
declare namespace xlr="http://ns.exiftool.ca/XMP/XMP-lr/1.0/";
declare namespace iptc="http://ns.exiftool.ca/IPTC/IPTC/1.0/";
declare namespace xmpdc="http://ns.exiftool.ca/XMP/XMP-dc/1.0/";
declare namespace exif="http://ns.exiftool.ca/EXIF/ExifIFD/1.0/";
declare namespace ifd0="http://ns.exiftool.ca/EXIF/IFD0/1.0/";
declare namespace exififd="http://ns.exiftool.ca/EXIF/ExifIFD/1.0/";
declare namespace composite="http://ns.exiftool.ca/Composite/1.0/";
                                                      
declare variable $query   := request:get-parameter("q","");
declare variable $keyword := request:get-parameter("keyword","");
declare variable $album   := request:get-parameter("album","");

declare option exist:serialize "method=xml media-type=text/html encoding=UTF-8";

declare function local:mk-record($doc as node()) as node() {
	let $about := $doc/@rdf:about/string()
	let $type  := $doc//f:FileType/string()
	let $uri   := concat("http://fsdata/photography/",$about)
	let $jfr   := replace($uri,"^(.*?)/([^/]*)$","$1/jfr/$2")
	return
	<div style="width:17.5%;float: left;">
	     {
	     if((matches($about,"png$","i") or matches($about,"jpe?g$","i")) and not( contains($about,'_jfr'))) then
	        <a rel="viewer" href="{$uri}"><img style="width: 95%" alt="{$about}" src="{$uri}"/></a>
	     else if(matches($about,"(DNG|ORF|RW2)$","i")) then
		<a href="{$uri}"><img style="width: 95%" alt="{$about}" src='{replace($jfr,"\.(DNG|ORF|RW2)$","_jfr.JPG","i")}'/></a>
	     else ""
	     }
	     <strong>Description </strong>{$doc//xmpdc:Description/text()}<br/>
	     <strong>Date </strong>{$doc//exififd:CreateDate}<br/>
	     <strong>Position </strong>{replace($doc//composite:GPSPosition/text(),"\s*deg","°","i")}<br/>
	     <a href="{$about}.xml">{util:document-name($doc)}</a> ||
	     <a href="search-keywords.xq?album={$doc//sys:Directory}">album</a><br/><strong>Keywords</strong>
	     {
		for $li in $doc//xmpdc:Subject/rdf:Bag/rdf:li
		let $kw := $li/text()
		order by $kw
		return <a href="search-keywords.xq?keyword={$kw}">{$kw}</a>
	     }
	</div>
};		

<html>
<head>
<title>
Search
</title>
  <script type='text/javascript'
	  src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js">
    //
  </script>
  <style>
    @import url("/css-style/colorbox.css");
  </style>
   <script type="text/javascript" src="/js/jquery.colorbox.js">
    //
  </script>
  <script type="text/javascript"><!-- //
    $(document).ready(function(){
    $("a[rel='viewer']").colorbox({rel:'viewer',height:'100%'});
    });
  //--></script>

</head>
<body>
<div style="width:99%;">
<a href="retrieve-keywords.xq">keywords</a> | <a href="retrieve-albums.xq">albums</a> | <a href="search-keywords.xq">search</a>
<h3>search</h3>

<form action="">
<input name="q" value="{$query}"/>
<input type="submit" value="search"/>
</form>

<h3>result</h3>
<div style="width:99%;">
{
let $hits :=
if($query) then
for $doc in collection("/db/galleri")//rdf:Description[ft:query(.,$query)]
order by $doc//exififd:CreateDate[string()][1] descending
return $doc
else if($keyword) then
for $doc in collection("/db/galleri")//rdf:Description[contains(xlr:HierarchicalSubject/rdf:Bag/rdf:li,$keyword) or contains(xmpdc:Subject/rdf:Bag/rdf:li,$keyword)]
order by $doc//exififd:CreateDate[string()][1] descending
return $doc
else if($album) then
for $doc in collection("/db/galleri")//rdf:Description[contains(sys:Directory,$album)]
order by $doc//exififd:CreateDate[string()][1] descending
return $doc
else ()

return
for $doc at $pos in $hits
let $rec := local:mk-record($doc)
let $br  := if($pos mod 5 eq 0) then <br style="clear:left;"/> else ()
return ($rec,$br)

}
</div>
</div>
</body>
</html>

