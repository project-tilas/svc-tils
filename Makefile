.PHONY: install test build serve clean pack serve-container deploy ship

TAG?=$(shell git rev-list HEAD --max-count=1 --abbrev-commit)

export TAG

install:
	dep ensure -vendor-only

test:
	go test ./...

build: install
	go build -ldflags "-X main.version=$(TAG)" -o svc-tils .

serve: build
	./svc-tils

clean:
	rm ./svc-tils

pack:
	GOOS=linux make build
	docker build -t github.com/project-tilas/svc-tils:$(TAG) .

serve-container:
	docker run -d -it -p 8080:8080 --name=svc-tils github.com/project-tilas/svc-tils:$(TAG)

upload:
	gcloud docker -- push github.com/project-tilas/svc-tils:$(TAG)

deploy:
	envsubst < k8s/deployment.yml | kubectl apply -f -

ship: test pack upload deploy clean