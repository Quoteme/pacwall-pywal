![screenshot](./screenshot.png)

`pacwall.sh` is a shell script that changes your wallpaper to the dependency graph of installed by pacman packages. Each package is a node and each edge indicates a dependency between two packages. The explicitly installed packages have a distinct color (orange by default).

## Changes in this fork
- (optionally) parse [pywal](https://github.com/dylanaraps/pywal/) for color data
	- colors for nodes, etc can be exchanged for other colors exported by pywal
	- if pywal is not installed (~/.cache/wal does not exist), use default colors
- feh removed, instead using hsetroot
	- hsetroot is more minimalistic (0.04MiB)
	- removes the dependency on imagemagic (9.72MiB)
	- removes the dependency on feh (0.17MiB)
	- removes the need to manually set SCREEN_SIZE

## Requirements
- graphviz
- pacman-contrib
- hsetroot
- python-pywal (optional)

`sudo pacman -S graphviz pacman-contrib hsetroot pywal`

## Customization
Any customizations should be performed by modifying the script itself. The code in the script is well-structured (should be). To discover the customization possibilities, read the man page of `graphviz` and `twopi`, particularly the section on GRAPH, NODE AND EDGE ATTRIBUTES.

## Troubleshooting
If the graph is too large, add a `-Gsize` flag to the `twopi` invocation, like here:

	twopi \
		-Gsize="7.5,7.5" \
		-Tpng pacwall.gv \
		-Gbgcolor=$BACKGROUND \
		-Ecolor=$EDGE\
		-Ncolor=$NODE \
		-Nshape=point \
		-Nheight=0.1 \
		-Nwidth=0.1 \
		-Earrowhead=normal \
		> pacwall.png
The flag forces the graph to be not wider nor higher than 7.5 *inches*.

An alternative method is to add a `-Granksep` flag. For example, `-Granksep=0.3` means that the distance between the concentric circles of the graph will be 0.3 inch.
