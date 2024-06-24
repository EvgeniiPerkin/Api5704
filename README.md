# Api5704

Передача сведений о среднемесячных платежах (ССП) по Указанию Банка
России от 11.01.2021 № 5704-У «О порядке и форме предоставления сведений
о среднемесячных платежах субъекта кредитной истории, о порядке и форме
запроса и предоставления квалифицированным бюро кредитных историй
сведений, необходимых для подготовки сведений о среднемесячных платежах
субъекта кредитной истории, а также о порядке предоставления данных,
необходимых для формирования и предоставления пользователям кредитных
историй сведений о среднемесячных платежах субъекта кредитной истории».

## Порядок взаимодействия с использованием API

«Порядок взаимодействия пользователей кредитных историй, бюро кредитных
историй, в том числе квалифицированных бюро кредитных историй, с
квалифицированными бюро кредитных историй с использованием программного
интерфейса приложения (API) в целях предоставления сведений о
среднемесячных платежах» публикуется в соответствии с пунктом 1.2
Указания Банка России № 5704-У:

<https://cbr.ru/ckki/transfer_inform/>

По этой ссылке важно отслеживать вступление в силу новых версий форматов.
Так, версия 1.3 вступает в силу с 10.07.2024.

Адрес базового URL API тестовой системы:
<https://reports.demo.nbki.ru/qbch/>

Адрес базового URL API тестовой системы, планируемой к выпуску:
<https://reports.test-alfa.nbki.ru/qbch/>

Адрес базового URL API промышленной системы:
<https://reports.nbki.ru/qbch/> (до 15.07.2024)
<https://ssp.nbki.ru/qbch/>

Для подключения требуется зарегистрированный через ЛК сертификат
и зачастую дополнительная привязка через Службу поддержки.

## Подготовка запросов

Для небольшого использования по подготовке и учету сделанных запросов
прилагается файл Microsoft Excel с макросами `Api5704.xslm`.

Как альтернативу Excel можно рассмотреть другой проект по составлению
шаблонных XML-запросов - <https://github.com/diev/ReplForms>.
Для этой программы положен файл шаблона в папку [Templates](Templates).

Разница между тем, запрашивает клиент ССП только в БКИ или в режиме
одного окна определяется значением параметра `ТипЗапроса`:

* ТипЗапроса="`1`" – запрашивает только в БКИ (до 01.07.2024);
* ТипЗапроса="`2`" – запрашивает одно окно КБКИ.

СНИЛС требуется указывать по формату `\d\d\d-\d\d\d-\d\d\d \d\d`.

ХэшКод требуется переводить в нижний регистр `[\da-f]{64}`.

С 10.07.2024 вступает в силу версия формата `1.3`.

## Config

При первом запуске будет создан файл настроек `Api5704.config.json`
с параметрами по умолчанию. Откорректируйте его перед новым запуском:

* `MyThumbprint` = отпечаток вашего сертификата для его выбора в Хранилище;
* `VerboseClient` = отображать содержимое вашего сертификата;
* `ServerAddress` = url сервера для подключения;
* `ServerThumbprint` = отпечаток сертификата сервера (опционально);
* `ValidateTls` = проверять действительность сертификатов TLS;
* `ValidateThumbprint` = проверять отпечаток сервера;
* `VerboseServer` = отображать содержимое сертификата сервера;
* `UseProxy` = использовать прокси;
* `ProxyAddress` = url прокси-сервера (опционально);
* `SignFile` = подписывать запросы в программе;
* `CleanSign` = удалять подписи ответов в программе;
* `CspTest` = путь к программе КриптоПро `csptest.exe` (опционально);
* `CspTestSignFile` = команда с параметрами для подписи запросов в
программе, где:
  * `%1` = исходный файл XML;
  * `%2` = подписанный файл XML.sig для отправки;
  * `%3` = будет подставлено значение `MyThumbprint` для выбора
сертификата в Хранилище для подписи.

## Usage

Предоставление сведений о среднемесячных платежах субъектов
кредитных историй:

    Api5704 запрос параметры

**dlput** – передача от КБКИ данных, необходимых для формирования
и предоставления пользователям кредитных историй сведений о
среднемесячных платежах Субъекта.

    Api5704 dlput qcb_put.xml result.xml

**dlrequest** – запрос сведений о среднемесячных платежах Субъекта.
Параметры: `request.xml[.sig] result.xml`
(`result.xml` будет создан с результатом операции).

    Api5704 dlrequest request.xml result.xml

**dlanswer** – получение сведений о среднемесячных платежах Субъекта
по идентификатору ответа.

    Api5704 dlanswer n6c80c1c8-f620-491c-994a-6886706d85dc answer.xml
    Api5704 dlanswer result.xml answer.xml

**dlputanswer** – получение информации о результатах загрузки данных,
необходимых для формирования и предоставления пользователям кредитных
историй сведений о среднемесячных платежах Субъекта, в базу данных КБКИ.
Параметры: `id answer.xml` (вместо `id` можно подставить `result.xml`
с ним из предыдущей операции, `answer.xml` будет создан с ответом).

    Api5704 dlputanswer 945cb186-0d50-45ff-8823-797942987638 answer.xml
    Api5704 dlputanswer result.xml answer.xml

**certadd** – добавление нового сертификата абонента.

    Api5704 certadd A6563526-A3F3-4D4E-A923-E41E93F1D921 cert.cer cert.cer.sig result.xml

**certrevoke** – отзыв сертификата абонента.
Параметры: `id cert.cer sign.sig result.xml`
(`result.xml` будет создан с результатом операции).

    Api5704 certrevoke A6563526-A3F3-4D4E-A923-E41E93F1D921 cert.cer cert.cer.sig result.xml

## Пример получения ССП в конфигурации с наложением ЭП программой

Получить новый GUID (пусть в данном примере
`6d20a9fd-7bce-4480-bf56-a66932876bf7`).
Подготовить файл запроса `request.xml`, где будет этот
`ИдентификаторЗапроса="6d20a9fd-7bce-4480-bf56-a66932876bf7"`.
Отправить файл командой `dlrequest`:

    Api5704 dlrequest request.xml result.xml

Посмотреть полученный (в случае успеха передачи) файл `result.xml`.
Там будет строка вида (одной строкой) с ответом на наш запрос:

    <ИдентификаторОтвета
    ИдентификаторЗапроса="6d20a9fd-7bce-4480-bf56-a66932876bf7">
    b17c7a39-359e-4e7c-941d-668e2e957a7c
    </ИдентификаторОтвета>

Вот этот идентификатор ответа надо через некоторое время
отправить командой для получения ответного файла с ССП:

    Api5704 dlanswer b17c7a39-359e-4e7c-941d-668e2e957a7c answer.xml

Другой вариант проще - запустить запрос с файлом из предыдущего этапа -
программа возьмет ИдентификаторОтвета из него сама:

    Api5704 dlanswer result.xml answer.xml

Полученный файл `answer.xml` содержит искомую информацию с ССП.

## Вычисление ХэшКода согласий

    "C:\Program Files (x86)\Crypto Pro\CSP\cpverify.exe" -mk -alg GR3411_2012_256 file.pdf
    A36D628486A17D934BE027C9CAF79B27D7CD9E4E49469D97312B40AD6228D26F

## Проверка ХэшКода на сервисе Госуслуг

<https://www.gosuslugi.ru/pgu/eds>

## Requirements

* .NET 8

## Versioning

Номер версии программы указывается по нарастающему принципу:

* Требуемая версия .NET (8);
* Год разработки (2024);
* Месяц без первого нуля и день редакции (624 - 24.06.2024);
* Номер билда - просто нарастающее число для внутренних отличий.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
