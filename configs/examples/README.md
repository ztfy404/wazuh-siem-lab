# Примеры настроек

Здесь я оставил три небольших XML-примера для похожего стенда:

- [client.fragment.xml](client.fragment.xml) — адрес Manager.
- [auth-localfile.fragment.xml](auth-localfile.fragment.xml) — чтение `/var/log/auth.log`.
- [fim-syscheck.fragment.xml](fim-syscheck.fragment.xml) — контроль тестового каталога.

Это примеры, а не копия моего полного `ossec.conf`. В `client.fragment.xml` нужно заменить `WAZUH_SERVER_IP` на свой адрес.

Фрагменты нужно объединять с существующими секциями конфига. Не стоит заменять ими весь файл или добавлять второй `syscheck`/`client`. Источник `auth.log` тоже может быть уже настроен.

В примере FIM указан `realtime="yes"`. Нужно проверить, подходит ли он своей системе и появляется ли событие после изменения файла. Корректный XML сам по себе не гарантирует работу мониторинга.
