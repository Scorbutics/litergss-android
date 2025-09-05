set(patchelf_version "0.12")

add_custom_target(host COMMAND
    if test -f ${CMAKE_BINARY_DIR}/target/host/usr/local/bin/patchelf\; then exit 0\; fi\; mkdir -p /tmp/build_dir/ && cd /tmp/build_dir/ &&
    wget https://github.com/NixOS/patchelf/archive/refs/tags/${patchelf_version}.tar.gz -O patchelf-${patchelf_version}.tar.gz &&
    tar -zxf patchelf-${patchelf_version}.tar.gz && cd patchelf-${patchelf_version} &&
    ./bootstrap.sh && ./configure && make && mkdir -p ${CMAKE_BINARY_DIR}/target/host/ && make install DESTDIR=${CMAKE_BINARY_DIR}/target/host/
)