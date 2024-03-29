cmake_minimum_required(VERSION 3.9)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

project(LiteRGSS2 CXX)

set(BASE_SOURCE_DIR build_dir/litergss2-2.0.0)

file(GLOB_RECURSE SOURCES
  ${BASE_SOURCE_DIR}/ext/LiteRGSS/*.h
	${BASE_SOURCE_DIR}/ext/LiteRGSS/*.cpp
)

string(REGEX REPLACE "[^;]*CMakeFiles/[^;]+;?" "" SOURCES "${SOURCES}")

add_library(LiteRGSS ${SOURCES})

set_target_properties(LiteRGSS PROPERTIES PREFIX "")
set(TARGET_LIBS LiteCGSS_engine sfml-graphics sfml-window sfml-system ruby physfs skalog)
target_link_libraries(LiteRGSS ${TARGET_LIBS})
