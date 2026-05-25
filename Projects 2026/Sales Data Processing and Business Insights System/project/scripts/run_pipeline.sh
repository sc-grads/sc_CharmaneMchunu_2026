#!/bin/bash

cd "$(dirname "$0")/.." #go to project root

#create venv if it doesnt exit

if [ ! -d "venv" ]; then
	python3 -m venv venv

fi 

source venv/bin/activate

pip install

python scripts/process_data.py




