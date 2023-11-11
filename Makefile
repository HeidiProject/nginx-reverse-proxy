install:
	git clone https://github.com/HeidiProject/frontend.git
	git clone https://github.com/HeidiProject/backend.git
	git clone https://github.com/HeidiProject/image-server.git
	git clone https://github.com/HeidiProject/mxdb-server.git
	git clone https://github.com/HeidiProject/mxdb-streaming.git

build:
	docker-compose build --no-cache

deploy:
	sudo docker-compose up -d