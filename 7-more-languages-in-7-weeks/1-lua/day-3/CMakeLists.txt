cmake_minimum_required(VERSION 2.8)
project(play)

include_directories(/usr/include/lua5.3)
link_directories(/usr/lib/x86_64-linux-gnu)

add_executable(play play.cpp)
target_link_libraries(play lua5.3)
