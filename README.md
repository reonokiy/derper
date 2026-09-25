# derper

This public repository builds the official Tailscale `cmd/derper` source at
`v1.102.4` into a non-root, static Linux amd64 container. Both build and
runtime base images are digest-pinned. GitHub Actions builds the image on pull
requests and publishes `ghcr.io/reonokiy/derper:sha-<commit>` from `main`.

The production Kubernetes deployment lives in
[`reonokiy/talos`](https://github.com/reonokiy/talos). It pins the resulting
GHCR image by digest, points `-verify-client-url` at Headscale's `/verify`
endpoint, and explicitly sets `-verify-client-url-fail-open=false`.

The image starts no service without arguments. Run `derper -h` to inspect
upstream options. The Kubernetes deployment terminates TLS at Envoy Gateway,
so `derper` listens on an internal HTTP port and exposes STUN directly over
UDP/3478. The public DERP package must be set to **Public** in GitHub Packages
before Kubernetes can pull it without a registry credential; repository
visibility alone does not change package visibility.
