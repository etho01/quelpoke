# Multi-stage build for quelpoke Go app
# 1) Build a static Linux binary with Go
# 2) Run it in a minimal scratch image with CA certs for HTTPS

# ---- Build stage ----
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Install CA certs (for copying to the final image)
RUN apk add --no-cache ca-certificates

# Enable Go module caching
COPY go.mod ./
RUN go mod download

# Copy the rest of the sources (includes embedded template)
COPY . .

# Build a static binary
ENV CGO_ENABLED=0
ENV GOOS=linux
# GOARCH will default to the build platform; override at build time if needed
RUN go build -trimpath -ldflags="-s -w" -o /out/quelpoke .

# ---- Runtime stage ----
FROM scratch

# Copy CA certificates so HTTPS requests (PokeAPI) work
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the built binary
COPY --from=builder /out/quelpoke /quelpoke

# Default server port
ENV PORT=8080
EXPOSE 8080

# Optionally set app version at runtime: -e VERSION=1.0.0
ENTRYPOINT ["/quelpoke"]
