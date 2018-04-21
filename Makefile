.PHONY: install test build serve clean pack serve-container deploy ship

TAG?=$(shell git rev-list HEAD --max-count=1 --abbrev-commit)

export TAG

install:
	dep ensure -vendor-only

test:
	go test ./...

build: install
	go build -ldflags "-X main.version=$(TAG)" -o svc-tils .


clean:
	rm ./svc-tils

pack:
	GOOS=linux make build
	docker build -t gcr.io/project-tilas/svc-tils:$(TAG) .

serve: pack
	docker run -d -it -p 8080:8080 --name=svc-tils gcr.io/project-tilas/svc-tils:$(TAG)

upload:
	docker push gcr.io/project-tilas/svc-tils:$(TAG)

deploy:
	envsubst < k8s/deployment.yml | kubectl apply -f -

ship: test pack upload deploy clean