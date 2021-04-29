set(patchelf_version "0.12")
execute_process(COMMAND 
    /bin/bash "-c" "[ -f ${CMAKE_SOURCE_DIR}/target/host/usr/local/bin/patchelf ] && exit 0; mkdir -p host/build_dir/ && cd host/build_dir/ &&
    wget https://github.com/NixOS/patchelf/archive/refs/tags/${patchelf_version}.tar.gz -O patchelf-${patchelf_version}.tar.gz &&
    tar -zxf patchelf-${patchelf_version}.tar.gz && cd patchelf-${patchelf_version} &&
    ./bootstrap.sh && ./configure && make && mkdir -p ${CMAKE_SOURCE_DIR}/target/host/ && make install DESTDIR=${CMAKE_SOURCE_DIR}/target/host/"
)
