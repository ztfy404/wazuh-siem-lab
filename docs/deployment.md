# Установка Wazuh

Я развернул серверную часть на Ubuntu Server 24.04 LTS. Выбрал All-in-One: все серверные компоненты находятся на одной виртуальной машине.

## Порядок работы

1. Подготовил виртуальную машину Ubuntu в VirtualBox.
2. Настроил сеть и проверил доступ к машине.
3. Установил Wazuh Manager, Indexer, Dashboard и Filebeat.
4. Проверил запуск служб и подключение Filebeat к Indexer.
5. Открыл Dashboard в браузере.
6. Перешёл к [подключению агента](agent-setup.md).

Полную историю команд установки я здесь не привожу. Для повторения оставил [официальную инструкцию Wazuh](https://documentation.wazuh.com/current/quickstart.html). Нужно выбирать документацию под устанавливаемую версию: у меня Wazuh 4.14.10, а ссылка `current` со временем меняется.

## Проверка сервера

Состояние служб можно посмотреть так:

```bash
systemctl is-active wazuh-manager wazuh-indexer filebeat wazuh-dashboard
```

Версии установленных пакетов:

```bash
dpkg-query -W -f='${binary:Package}\t${Version}\n' \
  wazuh-manager wazuh-indexer wazuh-dashboard filebeat
```

Проверка подключения Filebeat:

```bash
sudo filebeat test output
```

У меня проверка Filebeat прошла: TLS handshake и соединение с Indexer были успешными.

Для Dashboard нужно открыть в браузере `https://WAZUH_SERVER_IP` и войти под своей учётной записью.

Если служба не запускается, её состояние и последние сообщения можно посмотреть так:

```bash
sudo systemctl status wazuh-indexer --no-pager
sudo journalctl -u wazuh-indexer -n 50 --no-pager
```

Это короткая памятка для повторной проверки, а не полный журнал команд установки.
