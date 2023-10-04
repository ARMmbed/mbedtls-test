#!/bin/sh
#
# Copyright (C) 2017, ARM Limited, All Rights Reserved
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This file is part of mbed TLS (https://tls.mbed.org)

# Build all variants of mbed TLS for fuzzing

set -eu

VERSION=

while [ $# -gt 0 ]
do
    case "$1" in
        --version)
            VERSION=$2
            shift
            ;;
        --force-reconfigure)
            FORCE=1
            ;;
        *)
            break
            ;;
    esac
    shift
done

DIR="$1"

[ ! -d "$DIR" ] && exit 0
cd "$DIR"

if [ ! -z ${FORCE:-} ]; then
    rm -rf build
fi

mkdir -p build/standalone
mkdir -p build/libfuzzer-fast
mkdir -p build/libfuzzer-asan-ubsan
mkdir -p build/libfuzzer-msan
mkdir -p build/libfuzzer-coverage
mkdir -p build/afl

# Standalone is a regular installation of mbed TLS
cd build/standalone

cmake -DCMAKE_C_COMPILER=clang-6.0 \
    -DENABLE_PROGRAMS=On \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=On \
    -DCMAKE_C_FLAGS="${CFLAGS}" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls" \
    -G Ninja \
    ../..
ninja
ninja install

# Build for fuzz_fast_* executables
cd ../../build/libfuzzer-fast

cmake -DCMAKE_C_COMPILER=clang-6.0 \
    -DENABLE_PROGRAMS=Off \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=Off \
    -DCMAKE_C_FLAGS="${FAST_CFLAGS}" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls-libfuzzer-fast" \
    -G Ninja \
    ../..
ninja
ninja install

# Build for fuzz_asan_* executables (enables address sanitizer)
cd ../../build/libfuzzer-asan-ubsan

cmake -DCMAKE_C_COMPILER=clang-6.0 \
    -DENABLE_PROGRAMS=Off \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=Off \
    -DCMAKE_C_FLAGS="${ASAN_CFLAGS}" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls-libfuzzer-asan-ubsan" \
    -G Ninja \
    ../..
ninja
ninja install

# Build for fuzz_msan_* executables (enables memory sanitizer)
cd ../../build/libfuzzer-msan

cmake -DCMAKE_C_COMPILER=clang-6.0 \
    -DENABLE_PROGRAMS=Off \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=Off \
    -DCMAKE_C_FLAGS="${MSAN_CFLAGS}" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls-libfuzzer-msan" \
    -G Ninja \
    ../..
ninja
ninja install

# Build for coverage_* executables (enables instrumentation for coverage)
cd ../../build/libfuzzer-coverage

cmake -DCMAKE_C_COMPILER=clang-6.0 \
    -DENABLE_PROGRAMS=Off \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=Off \
    -DCMAKE_C_FLAGS="${COVERAGE_CFLAGS}" \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls-libfuzzer-coverage" \
    -G Ninja \
    ../..
ninja
ninja install

# Build for afl_* executables (suitable for running from afl-fuzz)
cd ../../build/afl

cmake -DCMAKE_C_COMPILER=afl-clang-fast \
    -DENABLE_PROGRAMS=Off \
    -DENABLE_TESTING=Off \
    -DINSTALL_MBEDTLS_HEADERS=Off \
    -DCMAKE_INSTALL_PREFIX="/usr/local/$VERSION/mbedtls-afl" \
    -G Ninja \
    ../..
ninja
ninja install

cd ../..