<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:XMP-dc='http://ns.exiftool.ca/XMP/XMP-dc/1.0/'
	       xmlns:XMP-lr='http://ns.exiftool.ca/XMP/XMP-lr/1.0/'
	       xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
	       xmlns:IPTC='http://ns.exiftool.ca/IPTC/IPTC/1.0/'
	       version="1.0">

  <xsl:output method="text"
	      encoding="UTF-8"/>
  
  <xsl:template match="/">
<xsl:text>
# removing those elements we are editing here      
del Xmp.dc.description      
del Xmp.dc.subject
del Xmp.lr.hierarchicalSubject
# Description
set Xmp.dc.description </xsl:text><xsl:for-each select="//XMP-dc:Description|//IPTC:Caption-Abstract"><xsl:value-of select="normalize-space(.)"/><xsl:text> </xsl:text></xsl:for-each>
<xsl:text>
  
# keywords (Should be in a XmpBag)
</xsl:text>
    <xsl:for-each select="//XMP-dc:Subject|//IPTC:Keywords">
      <xsl:for-each select="rdf:Bag">
	<xsl:for-each select="rdf:li">
	  <xsl:text>set Xmp.dc.subject </xsl:text><xsl:if test="position() = 1"><xsl:text>XmpBag </xsl:text></xsl:if><xsl:value-of select="normalize-space(.)"/><xsl:text>
</xsl:text>	  
	</xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="//IPTC:Keywords">
      <xsl:text>set Xmp.dc.subject </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>
</xsl:text>	  
    </xsl:for-each>
<xsl:text>
# hierarchical subject for navigation
</xsl:text>
    <xsl:for-each select="//XMP-lr:HierarchicalSubject">
      <xsl:for-each select="rdf:Bag">
	<xsl:for-each select="rdf:li">
	  <xsl:text>set Xmp.lr.hierarchicalSubject </xsl:text><xsl:if test="position() = 1"><xsl:text>XmpBag </xsl:text></xsl:if><xsl:value-of select="normalize-space(.)"/><xsl:text>
</xsl:text>
	</xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:transform>
