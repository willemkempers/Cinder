#!/usr/bin/env bash

# Set this to your CMake project name. Default argument is the folder name
readonly project="${PWD##*/}"

function build() {
    local build_type=$1
    mkdir -p build
    (
        cd build
        cmake -S ../proj/cmake -B . -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=$build_type
        cmake --build .
    )
}

function clean() {
    rm -rf ./build
}

function run() {
    local build_type=$1
    if [ "$(uname)" == "Darwin" ]; then
        local app_path="./build/$build_type/${project}/${project}.app/Contents/MacOS/${project}"
        eval " $app_path"
        [[ $? != 0 ]] && exit
    # elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    #     eval " $app_path"
    #     [[ $? != 0 ]] && exit
    else
        echo "run function: unsupported OS"
        exit 255
    fi
}

function build_and_run() {
    local build_type=$1
    build $build_type
    if [ $? -eq 0 ]; then
        run $build_type
    fi
}

function main() {
    local action=${1,,}
    local version=${2,,}

    if [[ $action == "" ]]; then
        build_and_run "Debug"
        [[ $? != 0 ]] && exit
    elif [[ $action == "debug" ]]; then
        local build_type=${action^}
        build_and_run $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "release" ]]; then
        local build_type=${action^}
        build_and_run $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "build" ]]; then
        local build_type=${version^}
        build $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "run" ]]; then
        local build_type=${version^}
        run $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "clean" ]]; then
        clean
        [[ $? != 0 ]] && exit
    else
        echo "usage: $0 [build|run|debug|release|clean] [debug|release]"
        exit 255
    fi
}

main $@