<?xml version="1.0" encoding="UTF-8"?>
<!--
  2. XML → HTML-таблица.
  Ожидаемый вход:
  <items>
    <item><name>...</name><price>...</price><qty>...</qty></item>
  </items>
  Колонки строятся автоматически по дочерним элементам первого <item>.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Отчёт</title>
        <style>
          body { font-family: sans-serif; margin: 2em; }
          table { border-collapse: collapse; }
          th, td { border: 1px solid #ccc; padding: 6px 12px; text-align: left; }
          th { background: #f0f0f0; }
          tr:nth-child(even) td { background: #fafafa; }
        </style>
      </head>
      <body>
        <h1>Отчёт</h1>
        <p>Всего записей: <xsl:value-of select="count(/*/*)"/></p>
        <table>
          <thead>
            <tr>
              <xsl:for-each select="/*/*[1]/*">
                <th><xsl:value-of select="local-name()"/></th>
              </xsl:for-each>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="/*/*"/>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/*/*">
    <tr>
      <xsl:for-each select="*">
        <td><xsl:value-of select="."/></td>
      </xsl:for-each>
    </tr>
  </xsl:template>
</xsl:stylesheet>
