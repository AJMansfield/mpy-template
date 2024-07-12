# Compiling This Project

## Graphical Overview

```mermaid
graph BT
factory["`Production Unit
    Factory`"]
validation["`Test Unit
    Validation`"]
developer["`Developer Unit
    Debugging`"]

release["`Release Firmware
    _build/firmware.uf2_`"]
release -- "`reel programmer`" --> factory
release -- "`UF2 boot`" --> validation

debug["`Debug Firmware
    _build/debug.uf2_`"]
debug -- "`UF2 boot`" --> developer

debugfs["`Debug Filesystem`"]
debugfs --> developer

mpy["`Micropython
    _micropython/_`"]
mpy -- "`make: release`" --> release
mpy -- "`make: debug`" --> debug

bytecode["`Bytecode
    _build/**.mpy_`"]
bytecode -- "`freeze`" --> release

app["`Application Python Code
    _app/**.py_`"]
app -- "`mpy-cross`" --> bytecode
app -- "`mpremote`" --> debugfs
```

## Release Build Process

To build the release firmware:

```bash
source tools.sh
install_build_tools
build_release
```

Release firmware should be at `build/firmware.uf2`.

## Debug Setup

TODO