# esp

## Build image (if needed)
```
cd esp-docker
git submodule update --init
docker compose build
# or
docker build --rm --pull -f ./Dockerfile -t esp:2024.2.0 .
```

## Prepare
Put your projects in the esp directory, e.g.,
```
cd esp/socs
git clone ssh://path/to/my-soc.git
cd ../accelerators/vivado_hls
git clone ssh://path/to/my-accelerator_vivado.git
cd ../rtl
git clone ssh://path/to/another-accelerator_rtl.git
# maybe put some work in work
cd work
git clone ssh://path/to/some_repo.git
```

## Run container
```
# X forwarding
cp ~/.Xauthority ./env/
# put your Xilinx license into env, or change path in scripts/bash_aliases.
cp /path/to/Xilinx.lic ./env/
# run docker with compose. preferred. edit docker-compose.yml to match
# your mount points.
docker compose run --rm -e UID=$(id -u) -e GID=$(id -g) esp
# when you quit use down to stop dependencies
docker compose down
# pruning can come in handy
docker system prune
docker network prune
# if you've recently changed the xilinx image you might need to nuke the old
# xilinx volume to create the correct new one. Creating the volume takes a
# long time, so only delete the old volume if you really need to.
docker volume prune --all

# or without compose. NB: This only works if you can mount vivado as a volume.
# The paths in that installation have to match the mount point in the
# container for the environment setting scripts to work. Also have to update
# XILINX_VIVADO path in scripts/bash_aliases to match, or set it manually from
# within the container.
docker run --rm -it --privileged --network=host -e DISPLAY=$DISPLAY -e UID=$(id -u) -e GID=$(id -g) -v`pwd`/env:/home/espuser/env:rw -v`pwd`/esp/socs/my-soc:/home/espuser/esp/socs/my-soc -v`pwd`/esp/accelerators/vivado_hls/my-accelerator_vivado:/home/espuser/esp/accelerators/vivado_hls/my-acclerator_vivado -v`pwd`/esp/accelerators/rtl/another-accelerator_rtl:/home/espuser/esp/accelerators/rtl/another-acclerator_rtl -v`pwd`/work:/home/espuser/work:rw -v/tools/Xilinx:/tools/Xilinx esp:2024.2.0
```

## speed up your simulation
Use `dummy.patch` as an example of how to patch your baremetal application
to speed up RTL simulation that is run with
```
# develop and apply patch
cd esp/socs/my-soc
make my-accelerator_vivado-baremetal
TEST_PROGRAM=./soft-build/ariane/baremetal/my-accelerator_vivado.exe make sim-gui
```
