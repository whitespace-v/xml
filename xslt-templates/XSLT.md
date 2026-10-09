# XSLT

## Что такое XSLT

XSLT — язык правил, по которым XML-документ превращается в другой документ: XML другой структуры, HTML-страницу или текст (например CSV).

Процессор берёт два файла — данные (`.xml`) и правила (`.xsl`) — и выдаёт результат. Правила описывают, что выводить, когда процессор встречает тот или иной узел исходного XML.

| Что | Пример |
| --- | --- |
| Вход | `items.xml` — список товаров |
| Правила | `table.xsl` — «для каждого товара сделай строку таблицы» |
| Выход | `report.html` — готовая таблица |

Примеры ниже — XSLT 1.0: эта версия работает везде (браузеры, xsltproc, Java, .NET, PHP, Python). XSLT 2.0/3.0 удобнее, но требует процессора Saxon.

## Каркас XSL-файла

Любой XSL-файл — это XML с корнем `xsl:stylesheet`, настройкой вывода и одним или несколькими шаблонами.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- формат результата: xml | html | text -->
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- шаблон: срабатывает на корень документа -->
  <xsl:template match="/">
    <html>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
```

- Всё с префиксом `xsl:` — команды процессору.
- Всё остальное (`<html>`, `<td>`, текст) выводится в результат как есть.
- Строка `xmlns:xsl="..."` обязательна и пишется ровно так, иначе процессор не узнает команды.

### Пример целиком

Вход:

```xml
<items>
  <item><name>Ноутбук</name><price>85000</price></item>
  <item><name>Мышь</name><price>2500</price></item>
</items>
```

Правила:

```xml
<xsl:template match="/items">
  <ul>
    <xsl:for-each select="item">
      <li><xsl:value-of select="name"/> — <xsl:value-of select="price"/> руб.</li>
    </xsl:for-each>
  </ul>
</xsl:template>
```

Результат:

```html
<ul>
  <li>Ноутбук — 85000 руб.</li>
  <li>Мышь — 2500 руб.</li>
</ul>
```

## Основные инструкции

| Инструкция | Что делает | Пример |
| --- | --- | --- |
| `xsl:template match` | Правило для узлов, подходящих под шаблон | `<xsl:template match="item">…</xsl:template>` |
| `xsl:template name` | Именованный шаблон — вызывается как функция | `<xsl:template name="fmt">…</xsl:template>` |
| `xsl:apply-templates` | Применить правила к дочерним (или выбранным) узлам | `<xsl:apply-templates select="item"/>` |
| `xsl:call-template` | Вызвать именованный шаблон | `<xsl:call-template name="fmt"/>` |
| `xsl:value-of` | Вывести текстовое значение | `<xsl:value-of select="name"/>` |
| `xsl:for-each` | Цикл по узлам | `<xsl:for-each select="item">…</xsl:for-each>` |
| `xsl:sort` | Сортировка (первым внутри for-each / apply-templates) | `<xsl:sort select="price" data-type="number" order="descending"/>` |
| `xsl:if` | Условие без «иначе» | `<xsl:if test="price &gt; 1000">дорого</xsl:if>` |
| `xsl:choose` | if / else if / else | см. ниже |
| `xsl:variable` | Переменная (менять нельзя) | `<xsl:variable name="total" select="sum(item/price)"/>` |
| `xsl:param` | Параметр шаблона или всего файла (задаётся снаружи) | `<xsl:param name="sep" select="','"/>` |
| `xsl:with-param` | Передать параметр в шаблон | `<xsl:with-param name="text" select="name"/>` |
| `xsl:copy` | Копировать текущий узел (без содержимого) | `<xsl:copy><xsl:apply-templates/></xsl:copy>` |
| `xsl:copy-of` | Копировать узел целиком со всем содержимым | `<xsl:copy-of select="address"/>` |
| `xsl:element` | Создать элемент с вычисляемым именем | `<xsl:element name="{local-name()}">…` |
| `xsl:attribute` | Добавить атрибут к создаваемому элементу | `<xsl:attribute name="class">red</xsl:attribute>` |
| `xsl:text` | Вывести текст точно, с пробелами и переносами | `<xsl:text>;</xsl:text>` |
| `xsl:key` | Индекс для быстрого поиска и группировки | `<xsl:key name="by-cat" match="order" use="@category"/>` |
| `xsl:output` | Формат результата | `<xsl:output method="text"/>` |
| `xsl:strip-space` | Убрать пробельные узлы из входа | `<xsl:strip-space elements="*"/>` |

### Условие с вариантами

```xml
<xsl:choose>
  <xsl:when test="price &gt; 50000">дорого</xsl:when>
  <xsl:when test="price &gt; 5000">средне</xsl:when>
  <xsl:otherwise>дёшево</xsl:otherwise>
</xsl:choose>
```

### Значение прямо в атрибуте

Фигурные скобки внутри атрибута вычисляют XPath:

```xml
<a href="/product/{@id}" title="{name}">Открыть</a>
```

### apply-templates или for-each

- `for-each` — «пройди по списку здесь и сейчас», проще для таблиц и списков.
- `apply-templates` — «найди подходящее правило для каждого узла», удобнее, когда структура разная или вложенная. Это основной стиль XSLT.

### Встроенные правила

Если для узла нет своего шаблона, процессор по умолчанию обходит его детей и выводит весь текст. Поэтому «лишний текст» в результате — признак того, что какой-то узел не перехвачен своим шаблоном. Пустой шаблон `<xsl:template match="comment"/>` удаляет узел.

## XPath — как указывать на данные

В атрибутах `match`, `select` и `test` пишется XPath — путь к нужным узлам, похожий на путь к файлу. Путь считается от текущего узла, если не начинается с `/`.

### Пути

| XPath | Что выбирает |
| --- | --- |
| `item` | дочерние `<item>` |
| `item/name` | `<name>` внутри `<item>` |
| `/items/item` | путь от корня документа |
| `//name` | `<name>` на любой глубине |
| `.` | текущий узел |
| `..` | родитель |
| `*` | любой дочерний элемент |
| `@id` | атрибут `id` |
| `@*` | все атрибуты |
| `text()` | текстовые узлы |
| `node()` | любые узлы (элементы, текст, комментарии) |
| `a \| b` | объединение: и `a`, и `b` |

### Фильтры в квадратных скобках

| XPath | Что выбирает |
| --- | --- |
| `item[1]` | первый `<item>` (счёт с 1) |
| `item[last()]` | последний |
| `item[@id='42']` | с атрибутом `id`, равным 42 |
| `item[price > 1000]` | с ценой больше 1000 |
| `item[name and price]` | у которых есть и `name`, и `price` |
| `item[not(@hidden)]` | без атрибута `hidden` |
| `item[contains(name, 'Мышь')]` | в названии есть «Мышь» |

### Операторы

`=` `!=` `<` `>` `<=` `>=` · `and` `or` `not()` · `+` `-` `*` `div` `mod`.
Внутри атрибутов XSL знак `<` обязательно пишется как `&lt;` (а `>` можно как `&gt;`). Деление — `div`, а не `/`.

### Функции

| Функция | Что делает | Пример → результат |
| --- | --- | --- |
| `count()` | количество узлов | `count(item)` → 3 |
| `sum()` | сумма чисел | `sum(item/price)` → 87500 |
| `position()` | номер в текущем цикле | `position()` → 1, 2, 3… |
| `last()` | число элементов в цикле | `position() != last()` |
| `concat()` | склейка строк | `concat(name, ' — ', price)` |
| `contains()` | есть ли подстрока | `contains(name, 'Pro')` |
| `starts-with()` | начинается ли с | `starts-with(@code, 'RU')` |
| `substring()` | часть строки | `substring('2026-10-09', 1, 4)` → 2026 |
| `substring-before()` / `-after()` | до / после разделителя | `substring-before('a,b', ',')` → a |
| `string-length()` | длина строки | `string-length(name)` |
| `normalize-space()` | убрать лишние пробелы | `normalize-space('  a  b ')` → a b |
| `translate()` | замена символов | `translate(., ',', '.')` |
| `format-number()` | формат числа | `format-number(1234.5, '#,##0.00')` → 1,234.50 |
| `round()` `floor()` `ceiling()` | округление | `round(2.6)` → 3 |
| `number()` / `string()` | приведение типа | `number(price)` |
| `local-name()` | имя тега без префикса | `local-name()` → item |
| `generate-id()` | уникальный id узла | для группировки |
| `key()` | поиск по `xsl:key` | `key('by-cat', 'Books')` |

## Как запускать

Быстрее всего начать с браузера или xsltproc; в программах XSLT подключается парой строк.

### Браузер

Второй строкой в XML укажите файл правил и откройте XML в Firefox:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="table.xsl"?>
<items>…</items>
```

Chrome не применяет XSL к локальным файлам — нужен локальный сервер (`python -m http.server`).

### xsltproc (командная строка)

Есть в Linux и macOS; для Windows — сборка libxslt.

```bash
xsltproc table.xsl items.xml > report.html
xsltproc --stringparam sep ";" to-csv.xsl items.xml > out.csv
```

### Python

```python
from lxml import etree  # pip install lxml
xslt = etree.XSLT(etree.parse("table.xsl"))
result = xslt(etree.parse("items.xml"), sep="';'")
print(str(result))
```

Строковые параметры в lxml передаются в кавычках внутри кавычек: `"';'"`.

### Другие способы

- Notepad++ — плагин XML Tools, пункт XSL Transformation.
- Java — `javax.xml.transform.TransformerFactory`.
- C# — `System.Xml.Xsl.XslCompiledTransform`.
- PHP — расширение `XSLTProcessor`.
- XSLT 2.0/3.0 — Saxon HE: `java -jar saxon-he.jar -s:items.xml -xsl:table.xsl -o:report.html`.

## Типичные ошибки

| Симптом | Причина | Что сделать |
| --- | --- | --- |
| Результат пустой, хотя данные есть | Во входном XML есть namespace (`xmlns="..."`), и `item` его не находит | Объявить префикс: `xmlns:d="тот же URI"` и писать `d:item`; или сначала прогнать шаблон удаления namespace |
| В результате весь текст подряд | Сработали встроенные правила для неперехваченных узлов | Добавить свой шаблон на корень `/` или пустые шаблоны на лишние узлы |
| Ошибка парсинга на `<` в условии | `<` внутри атрибута запрещён | Писать `&lt;`: `test="price &lt; 100"` |
| Ошибка «Comment must not contain '--'» | Двойное тире в комментарии `<!-- -->` | Убрать `--` из текста комментария |
| Сортировка 10, 2, 30 вместо 2, 10, 30 | Сортировка по умолчанию строковая | `<xsl:sort select="price" data-type="number"/>` |
| Лишние пустые строки в CSV/тексте | Пробелы и переносы из XSL и входа попадают в вывод | `<xsl:strip-space elements="*"/>`, текст через `<xsl:text>` |
| `for-each-group`, `tokenize`, `replace` не работают | Это функции XSLT 2.0 | Использовать Saxon или приёмы 1.0 (группировка Мюнха, рекурсивный шаблон) |
| Переменную нельзя изменить в цикле | Переменные в XSLT неизменяемы | Считать через `sum()`/`count()` или рекурсивный шаблон с параметром |
| `position()` даёт 2, 4, 6 | В `apply-templates` попали пробельные текстовые узлы | `select="item"` вместо пустого `apply-templates` или `strip-space` |