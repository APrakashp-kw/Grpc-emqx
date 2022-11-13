FROM golang:1.19 as build-env
WORKDIR /app/
COPY . ./
RUN go mod download
RUN go get -d -v ./... 
RUN go vet -v ./...
RUN go test -v ./...
RUN CGO_ENABLED=0 go build -o grpc main.go
FROM gcr.io/distroless/static
LABEL "microservice.name"="grpc"
COPY --from=build-env /app/grpc /
CMD ["/grpc"]