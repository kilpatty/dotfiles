#!/bin/sh	

__docker_started=0

__docker_init_async() {
	test $__docker_started = 0 && {
		eval "$(command open --background -a Docker)"
	}
}

__docker_init() {
	test $__docker_started = 0 && {
		command open --background -a Docker
		echo "Waiting for Docker to start..."

		while ! command docker system info > /dev/null 2>&1
		do
			sleep 5
		done
		__docker_started=1
	}
}

docker() {
	__docker_init
	command docker "$@"
}
