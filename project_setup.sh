#!/bin/bash

function print_help {
    echo "Usage: $0 DIRECTORY [--nogui]"
    echo
    echo "required arguments:"
    echo "  DIRECTORY   The directory where the Vivado project will be stored"
    echo
    echo "optional arguments:"
    echo "  --nogui     Do not start Vivado after setting up the project"

    exit 2
}

enable_gui=1
while :
do
    case "$1" in
        --nogui )
            enable_gui=0
            shift 1
            ;;
        --help )
            print_help
            ;;
        '')
            break
            ;;
        --*)
            echo "Unrecognized option: $1"
            print_help
            ;;
        *)
            [ ! -z $target_directory ] && print_help
            target_directory="$1"
            shift 1
            ;;
    esac
done

[ -z $target_directory ] && print_help

if [ ! -d $target_directory ]; then
    echo "Directory does not exist: $PWD/$target_directory"
    exit 2
fi

[ $enable_gui == 0 ] && extra_opts="-mode batch"
project_name=$(basename $target_directory)
vivado $extra_opts -source setup.tcl -tclargs $target_directory $project_name

