# Stage 1: Build static stress-ng from upstream sources
FROM debian:bookworm-slim AS builder

# Install build dependencies for static stress-ng
# Core deps only — keeps image minimal while supporting most stressors
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        zlib1g-dev \
        libaio-dev \
        libcap-dev \
        libattr1-dev \
        libsctp-dev \
        libatomic1 \
        libxxhash-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /code

# Download stress-ng sources
ARG STRESS_NG_VERSION
ADD https://github.com/ColinIanKing/stress-ng/archive/V${STRESS_NG_VERSION}.tar.gz .
RUN tar -xf V${STRESS_NG_VERSION}.tar.gz && mv stress-ng-${STRESS_NG_VERSION} stress-ng

# Build static binary
WORKDIR /code/stress-ng
RUN STATIC=1 make -j "$(nproc)" && strip stress-ng

# Verify the binary works
RUN ./stress-ng --version

# Final image: scratch with only the static binary
FROM scratch

COPY --from=builder /code/stress-ng/stress-ng /stress-ng

ENTRYPOINT ["/stress-ng"]
