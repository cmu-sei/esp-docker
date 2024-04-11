# esp

## Build image (if needed)
```
cd esp-docker
docker compose build
# or
docker build --rm --pull -f ./Dockerfile -t esp:2023.1.0 .
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
docker compose run -e UID=$(id -u) -e GID=$(id -g) esp

# or without compose. NB: This only works if you can mount vivado as a volume.
# The paths in that installation have to match the mount point in the
# container for the environment setting scripts to work. Also have to update
# XILINX_VIVADO path in scripts/bash_aliases to match, or set it manually from
# within the container.
docker run --rm -it --privileged --network=host -e DISPLAY=$DISPLAY -e UID=$(id -u) -e GID=$(id -g) -v`pwd`/env:/home/espuser/env:rw -v`pwd`/esp/socs/my-soc:/home/espuser/esp/socs/my-soc -v`pwd`/esp/accelerators/vivado_hls/my-accelerator_vivado:/home/espuser/esp/accelerators/vivado_hls/my-acclerator_vivado -v`pwd`/esp/accelerators/rtl/another-accelerator_rtl:/home/espuser/esp/accelerators/rtl/another-acclerator_rtl -v`pwd`/work:/home/espuser/work:rw -v/tools/Xilinx:/tools/Xilinx esp:2023.1.0
```
