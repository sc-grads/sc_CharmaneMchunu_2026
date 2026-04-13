#!/bin/bash

LOG_FILE="output/pipeline.log"

echo "Pipeline started: $(date)" >> "$LOG_FILE"
python3 process_data.py >> "$LOG_FILE" 2>&1

if  [ $? -eq 0 ]; then
	echo "STATUS: SUCCESS" >> "$LOG_FILE"
else
	echo "STATUS :FAILED" >> "$LOG_FILE"
fi

echo "Pipeline ended: $(date)" >> "$LOG_FILE"
