# Подключение Astra Linux

На второй виртуальной машине у меня Astra Linux Orel 2.12.46. Я установил Wazuh Agent 4.14.10, указал адрес сервера и зарегистрировал агент. После этого он появился в Dashboard.

## Как повторить

1. Проверить связь Astra Linux с сервером Wazuh.
2. Получить подходящий пакет агента через Dashboard или [документацию Wazuh](https://documentation.wazuh.com/current/installation-guide/wazuh-agent/index.html).
3. Установить пакет и указать адрес Manager.
4. Зарегистрировать агент и проверить его в Dashboard.

Для Astra Linux нужно отдельно проверить зависимости пакета и совместимость выбранной версии.

## Проверка агента

```bash
systemctl is-active wazuh-agent
dpkg-query -W -f='${binary:Package}\t${Version}\n' wazuh-agent
```

Для диагностики можно посмотреть `/var/ossec/logs/ossec.log`. Одного запущенного процесса мало: я также проверял, что агент виден в Dashboard и события доходят до сервера.

## Что я отслеживал

- `/var/log/auth.log` — события SSH и `sudo`.
- `/opt/siem-fim-test/` — изменения тестовых файлов.

В [configs/examples](../configs/examples/README.md) лежат короткие примеры настроек. Их нужно объединять с действующим `/var/ossec/etc/ossec.conf`, а не заменять ими весь файл. Перед изменениями стоит сохранить локальную копию конфига и проверить, не настроен ли этот источник уже.

После изменения и проверки конфига агент можно перезапустить:

```bash
sudo systemctl restart wazuh-agent
systemctl is-active wazuh-agent
```

Ключи регистрации и пароли я в репозиторий не добавляю.
