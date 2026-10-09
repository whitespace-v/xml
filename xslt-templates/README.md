# Топ-5 XSLT-шаблонов (XSLT 1.0)

| Файл | Назначение |
|---|---|
| 01-identity-transform.xsl | Копирование XML «как есть» + точечные правки (удалить/переименовать узлы) |
| 02-xml-to-html-table.xsl | Превращает список записей в HTML-таблицу со стилями |
| 03-grouping-muenchian.xsl | Группировка с подсчётом и суммой (метод Мюнха) |
| 04-xml-to-csv.xsl | Экспорт в CSV с экранированием и настраиваемым разделителем |
| 05-strip-namespaces.xsl | Удаление всех пространств имён |

Все шаблоны на XSLT 1.0 — работают в браузерах, xsltproc, .NET, Java, PHP, Saxon.

## Запуск

```bash
xsltproc 02-xml-to-html-table.xsl input.xml > report.html
xsltproc --stringparam sep ";" 04-xml-to-csv.xsl input.xml > out.csv
```

Папка `examples/` содержит тестовые входные XML-файлы.
