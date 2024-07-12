# YOUR_PROJECT_NAME_HERE
Micropython Project Template

It's recommended to **NOT** clone this project with `--recurse-submodules`; the `micropython` submodule has its own extensive submodules, not all of which are needed for most projects and which could take a very long time to clone.
Clone this project normally, then run a nonrecursive `git submodule update --init` to get just the first-order micropython submodule.

## Setup
The commands for setting up this project are available as functions/subcommands of `tools.sh` -- that is, `build_release` can be invoked either by:
```bash
source tools.sh
build_release
```
OR by
```bash
tools.sh build_release
```




## Build Process
See [Compilation](docs/compilation.md) for how to compile this firmware.

## Organization
```
firmware/
├── tools.sh            build and debugging scripts
├── manifest.py         micropython build manifest
├── micropython/        micropython repository (submodule)
├── board/              board definition for this project
│   ├── main.py         main application logic
│   └── modules/        any application packages
├── docs/               documentation
├── app/
│   ├── main.py         main application logic
│   └── foolib/         any application packages
├── test/               tests for offline-testable code
└── build/
    └── firmware.uf2    compiled firmware image
```
