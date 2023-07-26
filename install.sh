#!/bin/bash

# Шаг 1: Установка Python и необходимых пакетов
sudo apt-get update
sudo apt-get install -y python3 python3-pip git

# Шаг 2: Клонирование репозитория с кодом проекта
git clone https://github.com/dimaskios/bot_ter_tg
cd bot_ter_tg

# Шаг 3: Создание и активация виртуального окружения
python3 -m venv venv
source venv/bin/activate

# Шаг 4: Установка зависимостей
pip install -r requirements.txt

# Шаг 5: Настройка базы данных (здесь предполагается PostgreSQL)
sudo apt-get install -y postgresql postgresql-contrib

sudo -u postgres psql -c "CREATE DATABASE your_db_name;"
sudo -u postgres psql -c "CREATE USER your_db_user WITH PASSWORD 'your_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE your_db_name TO your_db_user;"

# Шаг 6: Настройка файла settings.py для Django-приложения
cd your_django_app
cp settings.py.example settings.py
sed -i "s/your_db_name/your_db_name/g" settings.py
sed -i "s/your_db_user/your_db_user/g" settings.py
sed -i "s/your_password/your_password/g" settings.py

# Шаг 7: Применение миграций для Django-приложения
python manage.py migrate

# Шаг 8: Настройка Telegram бота
sed -i "s/your_telegram_bot_token/your_telegram_bot_token/g" your_telegram_bot.py

# Шаг 9: Запуск Django-приложения
nohup python manage.py runserver 0.0.0.0:8000 > django_app.log &

# Шаг 10: Запуск Telegram бота
nohup python your_telegram_bot.py > telegram_bot.log &

# Шаг 11: Дополнительные действия по настройке Terraform и Binance API (если требуется)
# ...

echo "Установка и развёртывание завершено!"
