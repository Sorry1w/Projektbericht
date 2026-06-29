#!/bin/bash
# Cold-start KPI: Zeit von docker compose up bis /health HTTP 200
TIMES=()
for i in 1 2 3; do
    docker compose down -q
    START=$(date +%s%3N)
    docker compose up -d -q
    until curl -sf http://localhost:8000/health > /dev/null; do sleep 0.1; done
    END=$(date +%s%3N)
    TIMES+=($((END - START)))
    echo "Lauf $i: $((END - START)) ms"
done
echo "Median: $(echo "${TIMES[@]}" | tr ' ' '\n' | sort -n | awk 'NR==2'} ms"
