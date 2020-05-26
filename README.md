# Issabel PBX

https://www.issabel.org/

Custom macvlan setup:

```shell
docker network create -d macvlan \
-o macvlan_mode=bridge \
--subnet=111.222.333.443/29 \
--gateway=111.222.333.444 \
-o parent=eth1 macvlan_bridge
```

For the firewall to work adding `--cap-add=NET_ADMIN` is necessary.
For best performance use `--net=host` or custom networking. 

```shell
docker run --name issabel \
-p 25:25 -p 82:80 -p 465:465 -p 2122:2122 -p 5038:5038 \
-p 5060:5060/tcp -p 5060:5060/udp -p 5061:5061/tcp -p 5061:5061/udp \
-p 8001:8001 -p 8003:8003 -p 8088:8088 -p 8089:8089 \
-p 9900:9900/tcp -p 9900:9900/udp -p 10000-10100:10000-10100/tcp -p 10000-10100:10000-10100/udp \
-v issabel-etc:/etc -v issabel-www:/var/www \
-v issabel-log:/var/log -v issabel-lib:/var/lib \
-v issabel-home:/home -v /etc/resolv.conf:/etc/resolv.conf:ro \
--cap-add=NET_ADMIN --restart=always --hostname=unified.pbx.host -d technoexpress/Issabel-PBX
```

This build also assume reverse proxy is setup. 
This build setup to use https://github.com/adi90x/rancher-active-proxy

```shell
-v /nginx/rancher-active-proxy/letsencrypt/archive/unified.pbx.host:/etc/letsencrypt/archive/unified.pbx.host \
-l rap.host=unified.pbx.host \
-l rap.le_host=unified.pbx.host \
-l rap.https_method=noredirect \
```

## Docker Hub

https://hub.docker.com/r/technoexpress/issabel-pbx/builds/ automatically builds the latest changes into images which can easily be pulled and ran with a simple `docker run` command. 
