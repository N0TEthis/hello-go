# Этап 1: сборка
FROM golang:1.27-alpine AS builder

WORKDIR /build

# Копируем файлы модулей
COPY go.mod go.sum* ./

# Скачиваем зависимости
RUN go mod download

# Копируем исходники
COPY . .

# Собираем статический бинарник
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o hello-go .

# Этап 2: запуск
FROM alpine:3.22

# Непривилегированный пользователь
RUN adduser -D appuser

USER appuser
WORKDIR /home/appuser

COPY --from=builder /build/hello-go ./hello-go

ENTRYPOINT ["./hello-go"]