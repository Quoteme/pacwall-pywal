#!/bin/bash
echo 'Generating the graph.'

mkdir -p /tmp/pacwall
cd /tmp/pacwall

epkgs="$(pacman -Qeq | tr '\n' ' ')"

mkdir -p stripped
mkdir -p raw

rm pkgcolors 2> /dev/null

for package in $epkgs
do
    echo "\"$package\" [color=green]" >> pkgcolors
    pactree -g "$package" > "raw/$package"
    sed -E \
        -e 's/\[.*\]//' \
        -e 's/>?=.*" ->/"->/' \
        -e 's/>?=.*"/"/' \
        -e '/START/d' \
        -e '/^node/d' \
        -e '/\}/d' \
        "raw/$package" > "stripped/$package"
done

cd stripped
echo 'strict digraph G {' > ../pacwall.gv
cat ../pkgcolors $epkgs >> ../pacwall.gv
echo '}' >> ../pacwall.gv

echo 'Rendering it.'
cd ..
twopi \
    -Tpng pacwall.gv \
    -Gbgcolor=darkred \
    -Ecolor='#eeeeee99' \
    -Ncolor='#00ff0099' \
    -Nshape=point \
    -Nheight=0.1 \
    -Nwidth=0.1 \
    -Earrowhead=none \
   > pacwall.png

echo 'Displaying it.'
feh pacwall.png
