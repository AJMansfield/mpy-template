#!/bin/bash

PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUTPUT_DIR="$PROJECT_DIR/build"

function get_package_manager {
  declare -A osInfo;
  osInfo[/etc/redhat-release]=yum
  osInfo[/etc/arch-release]=pacman
  osInfo[/etc/gentoo-release]=emerge
  osInfo[/etc/SuSE-release]=zypp
  osInfo[/etc/debian_version]=apt-get
  osInfo[/etc/alpine-release]=apk
  osInfo[/c/Windows]=winget

  for f in ${!osInfo[@]}
  do
      if [[ -e $f ]];then
          echo ${osInfo[$f]}
          return 0
      fi
  done
  
  echo "(unknown)"
  return 1
}

function install_build_tools {
  package_manager=$(get_package_manager)
  case $package_manager in
    apt-get)
      apt-get update "$@"
      apt-get install "$@" sudo git make cmake build-essential python3 gcc-arm-none-eabi libnewlib-arm-none-eabi libffi-dev pkg-config
    ;;
    apk)
      apk add sudo git make cmake build-essential python3 gcc-arm-none-eabi newlib libffi pkgconf
    ;;
    *)
      echo "$package_manager is not a supported package manager" >&2
      echo "Please install the following: sudo git make cmake build-essential python3 gcc-arm-none-eabi libnewlib-arm-none-eabi libffi-dev pkg-config"
      return 1
    ;;
  esac
}

function build_release {
  source "$PROJECT_DIR/micropython/tools/ci.sh"
  make ${MAKEOPTS} -C "$PROJECT_DIR/micropython/mpy-cross"
  make ${MAKEOPTS} -C "$PROJECT_DIR/micropython/ports/rp2" BOARD=YOUR_PROJECT_NAME_HERE BOARD_DIR="$PROJECT_DIR/board" submodules
  make ${MAKEOPTS} -C "$PROJECT_DIR/micropython/ports/rp2" BOARD=YOUR_PROJECT_NAME_HERE BOARD_DIR="$PROJECT_DIR/board" FROZEN_MANIFEST="$PROJECT_DIR/manifest.py"
  cp -r $PROJECT_DIR/micropython/ports/rp2/build-YOUR_PROJECT_NAME_HERE/ -T $OUTPUT_DIR
}

function build_clean {
  source "$PROJECT_DIR/micropython/tools/ci.sh"
  make ${MAKEOPTS} -C "$PROJECT_DIR/micropython/mpy-cross" clean
  make ${MAKEOPTS} -C "$PROJECT_DIR/micropython/ports/rp2" BOARD=YOUR_PROJECT_NAME_HERE BOARD_DIR="$PROJECT_DIR/board" clean
  rm -rd $OUTPUT_DIR || true
}

function rename_project {
  new_name="$1"
  old_name="${2:-Your Project Name Here}" # note: this script is self-modifying!

  old_name_const="$(<<<"$old_name" tr '[:lower:]' '[:upper:]' |  tr '[:blank:]-_' '_' )" # = YOUR_PROJECT_NAME_HERE
  old_name_title="${old_name}"                                                           # = Your Project Name Here
  old_name_file="$(<<<"$old_name" tr '[:upper:]' '[:lower:]' |  tr '[:blank:]-_' '_' )"  # = your_project_name_here

  new_name_const="$(<<<"$new_name" tr '[:lower:]' '[:upper:]' |  tr '[:blank:]-_' '_' )"
  new_name_title="${new_name}"
  new_name_file="$(<<<"$new_name" tr '[:upper:]' '[:lower:]' |  tr '[:blank:]-_' '_' )"

  mv "$PROJECT_DIR/board/${old_name_file}.h" "$PROJECT_DIR/board/${new_name_file}.h"

  for f in "README.md" "board/board.json" "board/mpconfigboard.cmake" "board/mpconfigboard.h" "board/${new_name_file}.h"
  do
    sed -i -e "s/${old_name_const}/${new_name_const}/g"\
           -e "s/${old_name_title}/${new_name_title}/g"\
           -e "s/${old_name_file}/${new_name_file}/g"\
           "$PROJECT_DIR/$f"
  done

  # apply self-modifications:
  source "$PROJECT_DIR/tools.sh"
}

# Check if script is being sourced (`source tools.sh`) and exit if so -- leaving the functions as first-order commands to be invoked later.
# Snippet from https://stackoverflow.com/a/28776166/1324631
if [ -n "$ZSH_VERSION" ]; then 
  case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
else  # Add additional POSIX-compatible shell names here, if needed.
  case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
fi


# If it's not being sourced, it's being run -- so instead evaluate the first argument as a subcommand.
# Snippet from https://stackoverflow.com/a/37257634/1324631
if declare -f "$1" >/dev/null 2>&1; then
  # invoke that function, passing arguments through
  "$@" # same as "$1" "$2" "$3" ... for full argument list
else
  echo "Subcommand $1 not recognized." >&2
  echo "Valid subcommands:" >&2
  declare -F | sed 's/^declare -f /    /g' >&2
fi