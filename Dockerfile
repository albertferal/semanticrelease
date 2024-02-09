# Primera etapa: Construcción
FROM python:3.9 AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY templates/ templates/
COPY visitas.db .

# Segunda etapa: Ejecución
FROM python:3.9-slim

WORKDIR /app

# Copia solo los archivos necesarios de la etapa de construcción
COPY --from=builder /app/app.py .
COPY --from=builder /app/templates/ templates/
COPY --from=builder /app/visitas.db .
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

EXPOSE 7070

CMD ["python", "app.py"]
