# Your Project Name Here
Micropython Project Template



## Setup
Do **NOT** clone this project with `--recurse-submodules`: The `micropython` submodule has like a billion sub-submodules so that operation will take literally forever, and you only need the handful that the build scripts automatically retrieve all on their own anyway.
Clone this project normally, then run a nonrecursive `git submodule update --init` to get just the first-order micropython submodule.

### Commands For This Project
The commands for setting up this project are available both as subcommands of `tools.sh`, AND as functions you can source from `tools.sh`.
That is, a command like `build_release` can be invoked either as:

```bash
tools.sh build_release
```
OR
```bash
source tools.sh
build_release
```

Either is valid; set up your own environment at your own leisure.

### Dependencies

Use the `install_build_tools` command to install all of the system-level dependencies.
This command should work for a debian-based system, and might work on an alpine-based system.
(On systems it doesn't support, it will instead just give _you_ a list of packages that need to be installed.)

### Naming The Project

Use the `rename_project` command to change all placeholder "Your Project Name Here" texts into suitable replacements for your project.
This command takes one argument, the name of your new project in `Title Case`; and will create `CONST_CASE` and `snake_case` versions from that automatically.
For instance, to name your project "Internet Widget Controller", run the command:

```bash
rename_project "Internet Widget Controller"
```

Please only use capital letters, lowercase letters, and spaces.

(Note, running this command a second time _should_ work assuming the name you chose the first time is sufficiently unique that the search-and-replace process won't confuse any existing symbols with it. Don't name your project "N", re-rename it to "J" and then come complaining that cmake doesn't know how to "APPEJD" something to a list, that's just your fault.)

### Other Project Info

Edit the file [`board/board.json`](board/board.json) to include your Vendor info and your URL in the appropriate places.

### Board Definition

Modify the contents of the [`board/`](board/) directory to set up your specific board. Pay specific attention to [`board/modules/board.py`](board/modules/board.py) -- this is where you should put python code defining the base-level abstractions from raw pin numbers into `Pin` objects (and possibly, some higher-level communications busses for boards with fixed I2C or SPI perhipherals on those pins).

### Application Code

Modify the contents of the [`app/`](app/) directory to define your application logic. Your main entrypoint is [`main.py`](app/main.py), while the other files [`foolib/`](app/foolib/) and [`bar.py`](app/bar.py) are meant as demonstrations of how you can import additional python modules.

### Building a Firmware Image

To compile a final `firmware.uf2` file to be uploaded to your board or otherwise programmed into its flash, run this command:

```bash
build_release
```

Once it completes, you can retrieve the resulting firmware image -- including frozen-in application python code -- at `build/firmware.uf2`.

See [Compilation](docs/compilation.md) for more information on how this process works internally, what sources it derives from, and other ways of building the firmware for faster iteration and debugging.

## Organization
```
firmware/
├── tools.sh            build scripts
├── micropython/ -> x   pointer to specific micropython commit (git submodule)
├── board/              board definition for this project
│   └── modules/
│       └── board.py    board-specific I/O abstraction
├── app/
│   ├── main.py         main application logic
│   ├── foolib/         example composite includeable
│   └── bar.py          example single-file includeable
└── build/
    └── firmware.uf2    eventual location of compiled firmware image
```
