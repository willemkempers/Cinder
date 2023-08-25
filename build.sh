#!/usr/bin/env bash

function build() {
    local build_type=$1
    mkdir -p build
    (
        cd build
        cmake -S .. -B . -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" -DCMAKE_OSX_DEPLOYMENT_TARGET="11.0"
        cmake --build .
    )
}

function clean() {
    rm -rf ./build
}

function main() {
    local action=${1,,}

    if [[ $action == "" ]]; then
        build "Debug"
        [[ $? != 0 ]] && exit
    elif [[ $action == "debug" ]]; then
        local build_type=${action^}
        build $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "release" ]]; then
        local build_type=${action^}
        build $build_type
        [[ $? != 0 ]] && exit
    elif [[ $action == "clean" ]]; then
        clean
        [[ $? != 0 ]] && exit
    else
        echo "usage: $0 [debug|release|clean]"
        exit 255
    fi
}

main $@