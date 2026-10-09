<?xml version="1.0" encoding="UTF-8"?>
<!--
  1. Identity Transform — базовый шаблон, копирующий XML без изменений.
  Основа для точечных правок: добавьте свои шаблоны, чтобы изменить/удалить
  только нужные узлы, а всё остальное скопируется как есть.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Копируем любой узел и атрибут рекурсивно -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Пример: удалить все элементы <comment> -->
  <xsl:template match="comment"/>

  <!-- Пример: переименовать <old-name> в <new-name>, сохранив содержимое -->
  <xsl:template match="old-name">
    <new-name>
      <xsl:apply-templates select="@* | node()"/>
    </new-name>
  </xsl:template>
</xsl:stylesheet>
