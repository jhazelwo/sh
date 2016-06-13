#!/bin/sh
#
# Create a Docker boiler-plate in current directory.
#
ME='"John Hazelwood" <jhazelwo@users.noreply.github.com>'

oops(){ echo "Cannot create $1, file already exists."; exit 1; }
for this in Dockerfile Env Build Run; do test -f ./$this && oops $this; done

install -v -m 0640 /dev/null Dockerfile
echo "FROM centos:7
MAINTAINER $ME
RUN yum clean all && yum -y upgrade && yum -y install which yum-utils tar
" > Dockerfile

install -v -m 0740 /dev/null Env
echo "
image_name=\"myproject/myimage\"
#nodename=\"--hostname=appserv01\"
#volumes=\"-v /export/appdata:/appdata\"
run_rm=\"--rm=true\"
build_rm=\"--force-rm=true\"
#shmsize=\"--shm-size=2g\"
#ports=\"-p 443:443 -p 80:80\"
" > Env

install -v -m 0740 /dev/null Run
echo "#!/bin/sh
. \$(dirname \$0)/Env
docker run \$nodename \$run_rm \$ports \$shmsize -ti \$volumes \$image_name \$@
" > Run

install -v -m 0740 /dev/null Build
echo "#!/bin/sh
. \$(dirname \$0)/Env
docker build \$build_rm -t \$image_name \$(dirname \$0)

[ \$? -eq 0 -a "please_\$1" = "please_clean" ] && {
    for this in \`/usr/bin/docker images |grep '<none>'|awk '{print \$3}'\`; do
        /usr/bin/docker rmi \$this
    done
}
" > Build

