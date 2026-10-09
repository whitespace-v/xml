<?xml version="1.0" encoding="UTF-8"?>
<!--
  4. XML → CSV.
  Заголовок строится по именам дочерних элементов первой записи.
  Значения экранируются: кавычки удваиваются, каждое поле в "...".
  Разделитель меняется параметром sep (пример запуска — в README.md).
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="sep" select="','"/>
  <xsl:variable name="nl" select="'&#10;'"/>

  <xsl:template match="/">
    <!-- Заголовок -->
    <xsl:for-each select="/*/*[1]/*">
      <xsl:value-of select="local-name()"/>
      <xsl:if test="position() != last()"><xsl:value-of select="$sep"/></xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$nl"/>

    <!-- Строки -->
    <xsl:for-each select="/*/*">
      <xsl:for-each select="*">
        <xsl:text>"</xsl:text>
        <xsl:call-template name="escape-quotes">
          <xsl:with-param name="text" select="normalize-space(.)"/>
        </xsl:call-template>
        <xsl:text>"</xsl:text>
        <xsl:if test="position() != last()"><xsl:value-of select="$sep"/></xsl:if>
      </xsl:for-each>
      <xsl:value-of select="$nl"/>
    </xsl:for-each>
  </xsl:template>

  <!-- Рекурсивная замена " на "" -->
  <xsl:template name="escape-quotes">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '&quot;')">
        <xsl:value-of select="substring-before($text, '&quot;')"/>
        <xsl:text>""</xsl:text>
        <xsl:call-template name="escape-quotes">
          <xsl:with-param name="text" select="substring-after($text, '&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
