# DOCKERIZED ASTERISK

### Maintainer: [leodadydev](https://github.com/leodaddydev)

### Description
- ASTERISK is a free and open source framework for building communications applications and is sponsored by Sangoma. We try to install and building asterisk version 16.8.0 with postgres realtime driver

### Prerequisite
 - Docker and docker-compose installed
 - Aterisk version >=16.8.0( lower version is not tested )

### How to start
- With docker-compose(dev & test only) <br />
  `docker build . -t asterisk:16.8.0`
  `docker-compose up -d`