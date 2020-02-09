# Reverse Proxy

This battle-tested, production-ready reverse proxy routes

## Usage

Without https (EG: on your machine for local environments):
```
./cmd/reverse-proxy.sh
```

With https (EG: in production):
```
./cmd/reverse-proxy-https.sh
```

### Credits:
[@progress44](https://github.com/progress44) — [Original Concept](https://github.com/blimpair/loadbalancer), Dockergen, Nginx, docker-composes

[@jrcs](https://github.com/jrcs) — [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
