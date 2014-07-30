<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/destination">

    <xsl:if test="/destination/introductory/introduction/overview">
      <h3>Introduction</h3>
      <p>
        <xsl:value-of select="/destination/introductory/introduction/overview"/>
      </p>
    </xsl:if>

    <xsl:if test="/destination/history">
      <h3>History</h3>
      <xsl:for-each select="/destination/history/history/history">
        <p>
          <xsl:value-of select="."/>
        </p>
      </xsl:for-each>
    </xsl:if>


  </xsl:template>
</xsl:stylesheet>
