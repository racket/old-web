<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="*"/>

  <xsl:template match="svn">
    <html>
      <head>
        <title>
          <xsl:if test="string-length(index/@name) != 0">
            <xsl:value-of select="index/@name"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="index/@path"/>
        </title>
        <link rel="stylesheet" type="text/css" href="/svnindex.css"/>
      </head>
      <body>
        <div class="navbar">
          <div class="content">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td rowspan="2">
                  <img src="http://plt-scheme.org/logo.png" alt="[logo]" style="vertical-align: middle; margin: 0em 0.25em 0em 0em; border: 0;" />
                </td>
                <td>
                  <span class="navtitle">PLT Scheme</span>
                </td>
                <td class="helpiconcell">
                  <span class="helpicon"><a href="help.html">Need Help?</a></span>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://plt-scheme.org/">About</a>
                    </span>
                  </span>
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://download.plt-scheme.org/">Download</a>
                    </span>
                  </span>
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://docs.plt-scheme.org/">Documentation</a>
                    </span>
                  </span>
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://planet.plt-scheme.org/">PLaneT</a>
                    </span>
                  </span>
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://plt-scheme.org/community.html">Community</a>
                    </span>
                  </span>
                  <span class="navitem">
                    <span class="navlink">
                      <a href="http://plt-scheme.org/outreach+research.html"><span>Outreach&#160;&amp;&#160;Research</span></a>
                    </span>
                  </span>
                  <span class="navitem">&#160;</span>
                </td>
              </tr>
            </table>
          </div>
        </div>
        <div class="content">
          <xsl:apply-templates/>
        </div>
        <div class="footer">
          <!--
          <xsl:text>Powered by </xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:text>Subversion</xsl:text>
          </xsl:element>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@version"/>
          -->
          <xsl:element name="a">
            <xsl:attribute name="href">http://plt-scheme.org/</xsl:attribute>
            <xsl:text>PLT Scheme</xsl:text>
          </xsl:element>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="index">
    <div class="rev">
      <xsl:if test="string-length(@name) != 0">
        <xsl:value-of select="@name"/>
        <xsl:if test="string-length(@rev) != 0">
          <xsl:text> &#8212; </xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="string-length(@rev) != 0">
        <xsl:text>Revision </xsl:text>
        <xsl:value-of select="@rev"/>
      </xsl:if>
    </div>
    <div class="path">
      <xsl:value-of select="@path"/>
      <xsl:if test="string-length(@path) > 1">
        <xsl:text>/</xsl:text>
      </xsl:if>
    </div>
    <xsl:apply-templates select="updir"/>
    <xsl:apply-templates select="dir"/>
    <xsl:apply-templates select="file"/>
  </xsl:template>

  <xsl:template match="updir">
    <div class="updir">
      <xsl:element name="a">
        <xsl:attribute name="href">..</xsl:attribute>
        <xsl:text>[..]/</xsl:text>
      </xsl:element>
    </div>
    <!-- xsl:apply-templates/ -->
  </xsl:template>

  <xsl:template match="dir">
    <div class="dir">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:element>
    </div>
    <!-- xsl:apply-templates/ -->
  </xsl:template>

  <xsl:template match="file">
    <div class="file">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </div>
    <!-- xsl:apply-templates/ -->
  </xsl:template>

</xsl:stylesheet>
