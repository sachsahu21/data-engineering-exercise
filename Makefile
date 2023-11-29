.PHONY: deps install up stop clean

interval?=20
loglevel?=INFO

deps:
	brew install pyenv
	brew install pipenv

install:
	pyenv install 3.10 || true
	pyenv local 3.10
	pipenv sync

up:
	docker compose up -d

stop:
	docker compose stop

clean:
	docker compose down --volumes

start:
	pipenv run python scripts/producer.py --loglevel $(loglevel) --interval $(interval)
