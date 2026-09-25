FROM golang:1.26-alpine3.22@sha256:727cfc3c40be55cd1bc9a4a059406b28a059857e3be752aa9d09531e12c20c56 AS build

ARG TAILSCALE_VERSION=v1.102.4
ENV CGO_ENABLED=0 GOBIN=/out GOTOOLCHAIN=auto
RUN go install tailscale.com/cmd/derper@${TAILSCALE_VERSION} && \
    go version -m /out/derper | grep -E '^[[:space:]]*mod[[:space:]]+tailscale[.]com[[:space:]]+v1[.]102[.]4[[:space:]]'

FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab
LABEL org.opencontainers.image.source="https://github.com/reonokiy/derper" \
      org.opencontainers.image.description="Pinned Tailscale DERP relay for Headscale"
COPY --from=build --chown=65532:65532 /out/derper /usr/local/bin/derper
USER 65532:65532
EXPOSE 8080/tcp 3478/udp
ENTRYPOINT ["/usr/local/bin/derper"]
