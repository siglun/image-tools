xquery version "3.0" encoding "UTF-8";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace sys="http://ns.exiftool.ca/File/System/1.0/";
declare namespace xlr="http://ns.exiftool.ca/XMP/XMP-lr/1.0/";
declare namespace iptc="http://ns.exiftool.ca/IPTC/IPTC/1.0/";

declare option exist:serialize "method=xml media-type=text/html encoding=UTF-8";

let $list :=
   for $li in distinct-values(collection("/db/galleri")//sys:Directory/text())
   let $kw := replace($li,"^\./","")
   order by $kw
   return $kw
   
return
<div>
<a href="retrieve-keywords.xq">keywords</a> | <a href="retrieve-albums.xq">albums</a> | <a href="search-keywords.xq">search</a>
<h3>albums</h3>
<ul>{
       for $item in distinct-values($list)
       let $term := replace($item,"^.+\|([^\|]+)$","$1")
       order by $item
       return <li><a href="search-keywords.xq?album={$term}">{$item}</a></li>
}</ul>
</div>
(:

IPTC:Caption-Abstract

xmlns:rdf=
xmlns:et="http://ns.exiftool.ca/1.0/"
xmlns:ExifTool="http://ns.exiftool.ca/ExifTool/1.0/"
xmlns:System="http://ns.exiftool.ca/File/System/1.0/"
xmlns:File="http://ns.exiftool.ca/File/1.0/" xmlns:I
FD0="http://ns.exiftool.ca/EXIF/IFD0/1.0/"
xmlns:SubIFD="http://ns.exiftool.ca/EXIF/SubIFD/1.0/"
xmlns:XMP-x="http://ns.exiftool.ca/XMP/XMP-x/1.0/"
xmlns:XMP-tiff="http://ns.exiftool.ca/XMP/XMP-tiff/1.0/"
xmlns:XMP-xmp="http://ns.exiftool.ca/XMP/XMP-xmp/1.0/"
xmlns:XMP-digiKam="http://ns.exiftool.ca/XMP/XMP-digiKam/1.0/"
xmlns:XMP-photoshop="http://ns.exiftool.ca/XMP/XMP-photoshop/1.0/"
xmlns:XMP-dc="http://ns.exiftool.ca/XMP/XMP-dc/1.0/"
xmlns:XMP-microsoft="http://ns.exiftool.ca/XMP/XMP-microsoft/1.0/"
xmlns:XMP-lr="http://ns.exiftool.ca/XMP/XMP-lr/1.0/"
xmlns:IPTC="http://ns.exiftool.ca/IPTC/IPTC/1.0/"
xmlns:ExifIFD="http://ns.exiftool.ca/EXIF/ExifIFD/1.0/"
xmlns:Leica="http://ns.exiftool.ca/MakerNotes/Leica/1.0/"
xmlns:Composite="http://ns.exiftool.ca/Composite/1.0/"
rdf:about="./201506-201506/L1013082.DNG"
et:toolkit="Image::ExifTool 10.10"
:)
