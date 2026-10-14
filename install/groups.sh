#!/bin/bash

getent group docker >/dev/null || sudo groupadd docker
sudo usermod -aG docker,uucp "$USER"
