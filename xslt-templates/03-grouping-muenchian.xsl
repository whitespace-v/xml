<?xml version="1.0" encoding="UTF-8"?>
<!--
  3. Группировка (метод Мюнха, XSLT 1.0) с подсчётом и суммой.
  Ожидаемый вход:
  <orders>
    <order category="Books" amount="120"/>
    <order category="Music" amount="40"/>
    ...
  </orders>
  В XSLT 2.0+ то же самое делается через xsl:for-each-group.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Ключ группировки -->
  <xsl:key name="by-category" match="order" use="@category"/>

  <xsl:template match="/orders">
    <summary>
      <!-- Берём только первый элемент каждой группы -->
      <xsl:for-each select="order[generate-id() = generate-id(key('by-category', @category)[1])]">
        <xsl:sort select="@category"/>
        <xsl:variable name="group" select="key('by-category', @category)"/>
        <category name="{@category}"
                  count="{count($group)}"
                  total="{sum($group/@amount)}"/>
      </xsl:for-each>
    </summary>
  </xsl:template>
</xsl:stylesheet>
