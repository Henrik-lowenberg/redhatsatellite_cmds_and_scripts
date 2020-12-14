#!/bin/bash
HOST=sat6host.some.domain
echo -n /dev/tcp/$HOST/53 || exit 1
echo -n /dev/udp/$HOST/53 || exit 2
echo -n /dev/udp/$HOST/67 || exit 3
echo -n /dev/udp/$HOST/69 || exit 3
echo -n /dev/tcp/$HOST/80 || exit 4
echo -n /dev/tcp/$HOST/443 || exit 5
echo -n /dev/tcp/$HOST/5647 || exit 6
echo -n /dev/tcp/$HOST/8000 || exit 7
echo -n /dev/tcp/$HOST/8140 || exit 8
echo -n /dev/tcp/$HOST/8443 || exit 9
echo -n /dev/tcp/$HOST/9090 || exit 10
