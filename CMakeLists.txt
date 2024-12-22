cmake_minimum_required(VERSION 3.10)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)

include_directories(include include/ir include/opt/pass include/sym include/target)

file(GLOB_RECURSE SOURCES "src/*.cpp" "src/ir/*.cpp" "src/opt/pass/*.cpp" "src/sym/*.cpp" "src/target/*.cpp")

add_executable(main ${SOURCES})