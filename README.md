# Reverse Proxy

This battle-tested, production-ready reverse proxy routes incoming requests to the matching containers.

📤🔀🐳🐳🐳🐳🐳

### Credits:
[@progress44](https://github.com/progress44) — [Original Concept](https://github.com/blimpair/loadbalancer), Dockergen, Nginx, docker-composes

[@jrcs](https://github.com/jrcs) — [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

I've basically just rearrangged their code/configs for three reasons: 
+ to be more modular and concise
+ to build and push automatically on dockerhub
+ to have a version I can manage separately

## Usage

**Without** https (Port 80 of your machine)
```bash
./cmd/reverse-proxy.sh
```

**With** https (Ports 443 and 80 of your machine)
```bash
./cmd/reverse-proxy-https.sh
```

For this to automagically route traffic to your containers you need:

+ Declare `VIRTUAL_HOST` and `VIRTUAL_PORT` environment variables.
+ Attach to `front-tier` network.

`VIRTUAL_PORT` defaults to 80 so you can omit it.

`VIRTUAL_HOST` can be a comma separated list of values.

> TIP: You can run many projects on the same machine. Basing on the hostname, the request will be routed to the correct container.

## Example

Here shown in docker-compose style, but same applies for regular docker commands.

```yaml

networks:
  - my-other-network
  - front-tier:
      external:
        name: front-tier

mysql:
  # ...
  environment:
    # ...
    - VIRTUAL_HOST: mysql.my-beautiful-project.test
    - VIRTUAL_PORT: 3306
  networks:
    - my-other-network
    - front-tier
    
backend:
  # ...
  environment:
    # ...
    - VIRTUAL_HOST: backend.my-beautiful-project.test
    - VIRTUAL_PORT: 8000
  networks:
    - my-other-network
    - front-tier
    
frontend:
  # ...
  environment:
    # ...
    # More than one hostname:
    - VIRTUAL_HOST: my-beautiful-project.test,frontend.my-beautiful-project.test
    # `VIRTUAL_PORT` omitted because it's default (80)
  networks:
    - my-other-network
    - front-tier

```

### Machine network configuration

If do not advertise your IP address with a DNS (EG: Locally), you need to edit `/etc/hosts` as such: 
```
127.0.0.1   mysql.my-beautiful-project.test
127.0.0.1   my-beautiful-project.test
# .... All the other containers you registered to the `front-tier` network in your docker-compose
```

If you advertise your machine's IP with a DNS (EG: Prod), then everything will work fine.

```bash
curl my-beautiful-project.com
```
Following the example above, the frontend container will answer.

The same applies to the following command:
```bash
curl -H 'Host: my-beautiful-project.com' <YOUR-MACHINE-IP>
``` 

## Modules

This system is comprised of 3 components:

+ [Dockergen](https://github.com/vinzdef/reverse-proxy.dockergen)
+ [Nginx](https://github.com/vinzdef/reverse-proxy.nginx)
+ [LetsEncrypt](https://github.com/vinzdef/reverse-proxy.letsencrypt)

The first two are required to register containers and route incoming requests.
The last one makes up certificates on the fly so you don't have to worry about HTTPS. 
[Or maybe you do](https://medium.com/swlh/why-lets-encrypt-is-a-really-really-really-bad-idea-d69308887801)

