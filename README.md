Docker container for ESP use
Copyright 2023 Carnegie Mellon University.
MIT (SEI)
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
This material is based upon work funded and supported by the Department of
Defense under Contract No. FA8702-15-D-0002 with Carnegie Mellon University
for the operation of the Software Engineering Institute, a federally funded
research and development center.
The view, opinions, and/or findings contained in this material are those of
the author(s) and should not be construed as an official Government position,
policy, or decision, unless designated by other documentation.
NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING
INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON
UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR
PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE
MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND
WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
[DISTRIBUTION STATEMENT A] This material has been approved for public release
and unlimited distribution.  Please see Copyright notice for non-US
Government use and distribution.
DM23-0186


# esp

## Prepare
Put your projects in the esp directory, e.g.,
```
cd esp/socs
git clone ssh://path/to/ldpc-soc.git
cd ../accelerators/vivado_hls
git clone ssh://path/to/ldpc_vivado.git
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
# run docker with compose. preferred.
docker compose run -e UID=$(id -u) -e GID=$(id -g) esp
# or without compose. NB: This only works if you can mount vivado as a volume.
# The paths in that installation have to match the mount point in the
# container for the environment setting scripts to work. Also have to update
# XILINX_VIVADO path in scripts/bash_aliases to match, or set it manually from
# within the container.
docker run --rm -it --privileged --network=host -e DISPLAY=$DISPLAY -e UID=$(id -u) -e GID=$(id -g) -v`pwd`/env:/home/espuser/env:rw -v`pwd`/esp/accelerators/vivado_hls/ldpc_vivado:/home/espuser/esp/accelerators/vivado_hls/ldpc_vivado -v`pwd`/esp/socs/ldpc-soc:/home/espuser/esp/socs/ldpc-soc -v`pwd`/work:/home/espuser/work:rw -v/tools/Xilinx:/tools/Xilinx esp:2023.1.0
```

## Build image
```
docker compose build
# or
docker build --rm --pull -f ./Dockerfile -t esp:2023.1.0 .
```
