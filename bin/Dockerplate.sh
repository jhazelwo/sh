#!/bin/sh
#
# Create a Docker boiler-plate in current directory.
#
ME='"John Hazelwood" <jhazelwo@users.noreply.github.com>'

oops(){ echo "Cannot create $1, file already exists."; exit 1; }
for this in Dockerfile container.sh; do test -f ./$this && oops $this; done

install -v -m 0640 /dev/null Dockerfile
cat << DOCKERFILE > Dockerfile
FROM ubuntu:16.04
MAINTAINER "John Hazelwood" <jhazelwo@users.noreply.github.com>
RUN apt-get clean && \\
  apt-get -y update && \\
  apt-get -y upgrade && \\
  apt-get -y install curl && \\
  apt-get clean && \\
  rm -rf /var/lib/apt/lists/* /var/cache/*
RUN install -d -m 0700 -o 1000 -g 1000 /home/human && \\
  groupadd --gid 1000 human && \\
  useradd --uid 1000 --gid 1000 --home-dir /home/human -M --shell /bin/bash human
USER human
ENTRYPOINT ["/bin/bash", "--login"]
DOCKERFILE

install -v -m 0740 /dev/null container.sh
cat << CONTAINER > container.sh
#!/bin/sh
contname="example"
image_name="jhazelwo/\${contname}:0.1"
nodename="--hostname=\${contname}"
runname="--name=\${contname}"
run_rm="--rm=true"
# run_rm="--detach"
build_rm="--force-rm=true"
# volumes="-v /home/human:/home/human"
with_tty="--tty"
with_interact="--interactive"
build_context=\$(dirname \$0)
ports="-p 2222:22"  # Outside:Inside
# startre="--restart=unless-stopped"

usage() {
    echo ""
    echo "\$0 build [clean]"
    echo ""
    echo "\$0 run"
    echo ""
}

do_build() {
    echo "build \$1"
    docker build \$build_rm --tag=\${image_name} \$build_context
    if [ \$? -eq 0 -a please_\$1 = please_clean ]; then
        for this in \`/usr/bin/docker images |grep '<none>'|awk '{print \$3}'\`; do
            /usr/bin/docker rmi \$this
        done
    fi
}

do_run() {
    docker run \$nodename \$runname \$run_rm \$ports \$volumes \$with_tty \$with_interact \$startre \$image_name \$@
}

do_kill() {
    docker kill \$contname
}

case "\$1" in
    build)
        do_build "\$2"
        ;;
    run)
        shift
        do_run "\$@"
        ;;
    kill)
        do_kill
        ;;
    *)
        usage
        ;;
esac
CONTAINER
