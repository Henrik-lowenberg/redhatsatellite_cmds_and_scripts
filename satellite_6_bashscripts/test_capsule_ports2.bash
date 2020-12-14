#!/bin/bash
HOST=sat6host.some.domain
timeout 2 bash -c "</dev/tcp/$HOST/53";echo $?
timeout 2 bash -c "</dev/udp/$HOST/53";echo $?
timeout 2 bash -c "</dev/udp/$HOST/67";echo $?
timeout 2 bash -c "</dev/udp/$HOST/69";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/80";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/443";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/5647";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/8000";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/8140";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/8443";echo $?
timeout 2 bash -c "</dev/tcp/$HOST/9090";echo $?
