.PHONY: deps install up stop clean

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

start: install
	pipenv run python scripts/producer.py
