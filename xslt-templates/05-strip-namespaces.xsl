<?xml version="1.0" encoding="UTF-8"?>
<!--
  5. Удаление пространств имён (namespaces).
  Превращает <ns:Item xmlns:ns="..."> в <Item>, сохраняя атрибуты,
  текст, комментарии и инструкции обработки.
  Полезно перед дальнейшей обработкой SOAP-ответов, XML из 1С, ФНС и т.п.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Элементы: пересоздаём без префикса и namespace -->
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Атрибуты: тоже без namespace -->
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- Текст, комментарии, PI — копируем как есть -->
  <xsl:template match="text() | comment() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>
</xsl:stylesheet>
