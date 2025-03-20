#!/bin/bash
patch_submodule() {
    folder="$1"
    ls
    cd "./$folder" || exit
    mapfile -t fnames < <(grep -- '^---' "../${folder}.patch" | cut -d' ' -f2 | cut -d'	' -f1)
    for name in "${fnames[@]}"; do
        git checkout "${name/$folder\//}"
    done
    patch  -Np1 --input="../${folder}.patch"
    cd ../
}

patch_submodule Hypr-DarkWindow
