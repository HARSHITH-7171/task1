# =========================
# Stage 1: Build Stage
# =========================
FROM golang:1.22.5 AS base

WORKDIR /app

# Copy dependency files first (for caching)
COPY go.mod .

# Install dependencies
RUN go mod download

# Copy full source code
COPY . .

# Build the application
RUN go build -o main .

# =========================
# Stage 2: Runtime Stage
# =========================
FROM gcr.io/distroless/base


# Copy only the compiled artifact from builder stage
COPY --from=base /app/main .

COPY --from=base /app/static ./static


# Expose application port
EXPOSE 8080

# Run the application
CMD ["./main"]