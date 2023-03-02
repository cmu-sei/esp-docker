# esp

## Prepare
Put your projects in the esp directory, e.g.,
```
cd esp/socs
git clone ssh://path/to/ldpc-soc.git
cd ../accelerators/vivado_hls
git clone ssh://path/to/ldpc_vivado.git
```

## Run container
```
# X forwarding
cp ~/.Xauthority ./env/
docker run --rm -it --privileged --network=host -e DISPLAY=$DISPLAY -e UID=$(id -u) -v`pwd`/env:/home/esp-user/env:rw -v`pwd`/esp/socs/ldpc-soc:/home/espuser/esp/socs/ldpc-soc -v`pwd`/esp/accelerators/vivado_hls/ldpc_vivado:/home/espuser/esp/accelerators/vivado_hls/ldpc_vivado -v/tools/Xilinx:/tools/Xilinx esp:2023.1.0
```

## Build image, with proxy if needed
```
docker build --rm --pull -f ./Dockerfile --build-arg PROXY=${HTTP_PROXY} -t esp:2023.1.0 .
```
