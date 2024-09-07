# take base as golang 1.21 and give alias base
FROM golang:1.23 as base
#Create working directiory as /app
WORKDIR /app
# Need to copy go.mod which has all dependencies
COPY go.mod .
# run go mod download to download all essential dependencies
RUN go mod download
# Copy all the srccode from local to dockerfile /app folder
COPY . .
# RUN to create or build go artifact or binary
RUN go build -o main .
# Now we can just use EXPOSE 8080 and CMD ["./main"] to complete this
# but we want to make it multistage for security and reducing image size
#######===============================#######
# 2nd stage of multistage begins here.
FROM gcr.io/distroless/base
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD ["./main"]

