cmake_minimum_required(VERSION 3.9)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

project(SFMLAudio CXX)

set(BASE_SOURCE_DIR build_dir/ruby-sfml-audio-1.0.0)

file(GLOB_RECURSE SOURCES
  ${BASE_SOURCE_DIR}/ext/SFMLAudio/*.h
	${BASE_SOURCE_DIR}/ext/SFMLAudio/*.cpp
)

string(REGEX REPLACE "[^;]*CMakeFiles/[^;]+;?" "" SOURCES "${SOURCES}")

add_library(SFMLAudio ${SOURCES})

set_target_properties(SFMLAudio PROPERTIES PREFIX "")
set(TARGET_LIBS sfml-audio sfml-system ruby)
target_link_libraries(SFMLAudio ${TARGET_LIBS})
