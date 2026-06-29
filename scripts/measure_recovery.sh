#!/bin/bash
# Recovery KPI: Zeit von kill -9 bis /health HTTP 200
TIMES=()
for i in 1 2 3; do
    PID=$(docker compose exec pixelwise pgrep -f uvicorn)
    docker compose exec pixelwise kill -9 $PID
    START=$(date +%s%3N)
    until curl -sf http://localhost:8000/health > /dev/null; do sleep 0.1; done
    END=$(date +%s%3N)
    TIMES+=($((END - START)))
    echo "Lauf $i: $((END - START)) ms"
done
echo "Median: $(echo "${TIMES[@]}" | tr ' ' '\n' | sort -n | awk 'NR==2'} ms"
