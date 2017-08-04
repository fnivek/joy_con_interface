cmake_minimum_required(VERSION 2.8.3 FATAL_ERROR)
project(JoyConInterface)

include_directories(include)

add_executable(unit_test
  src/unit_test.c
  src/joy_con_interface.c
)
