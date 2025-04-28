# Использую многоэтапную сборку для уменьшения размера итогового образа
FROM python:3.9-slim AS builder

# Устанавливаю зависимости в виртуальное окружение
WORKDIR /build
COPY . .
RUN pip install --no-cache-dir flask gunicorn

# Финальный этап с минимальными зависимостями
FROM python:3.9-slim
WORKDIR /app

# Копирую нужные файлы и устанавливаю зависимости
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY app.py /app/

# Добавляю метаданные образа
LABEL maintainer="**ФИО***"
LABEL version="1.0.0"
LABEL description="CI/CD Demo Flask Application"

# Настраиваю переменные окружения
ENV APP_VERSION=1.0.0
ENV PORT=5000

# Настраиваю проверку работоспособности контейнера
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/health || exit 1

# Открываю порт
EXPOSE ${PORT}

# Запускаю приложение через gunicorn для продакшн-окружения
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
