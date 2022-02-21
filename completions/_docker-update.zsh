#compdef docker-update

_docker-update() {
    local ret=1
    local -a containers

    containers+=($(docker container ls -a --format '{{.Names}}'))

    compadd -a containers && ret=0

    return ret
}

_docker-update
