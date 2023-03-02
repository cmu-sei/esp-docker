#!/bin/bash

license=$(<./scripts/License.txt)

echo "$license"

FILES="Dockerfile
     README.md
     Xilinx.lic
     ./env/README.md
     ./esp/accelerators/vivado_hls/README.md
     ./esp/socs/README.md
     ./scripts/addlicense.sh
     ./scripts/bash_aliases
     ./scripts/entrypoint.sh
     ./scripts/gitconfig"

for f in $FILES; do
    printf '%s\n%s\n' "$license" "$(cat $f)" > $f
done
