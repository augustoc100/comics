run:
	docker-compose up

test:
	docker-compose exec app rspec

lint:
	docker-compose exec app rubocop

lint-auto-correct:
	docker-compose exec app rubocop -a
