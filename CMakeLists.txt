# cmake -S . -B build
# cmake --build build

include(CMakePrintHelpers)

option(BUILD_CODEGRADE_TESTS "Build test suites into separate executables" OFF)

cmake_minimum_required(VERSION 3.10)
project(hw5 LANGUAGES CXX)
find_package(GTest REQUIRED)

set(CMAKE_CXX_STANDARD 14)

# Build standalone test case suites for CodeGrade. These are separate executables so that CodeGrade can run them individually.
file(GLOB SOURCES tests/src/tests_*.cpp)

# Extract the test suite names from the file paths
set(TEST_SUITES "init_print" "init_student_array" "insert" "delete" "search")
foreach(TEST_CASE_FILE ${TEST_CASE_FILES})
  get_filename_component(TEST_SUITE_NAME ${TEST_CASE_FILE} NAME_WE)
  list(APPEND TEST_SUITES ${TEST_SUITE_NAME})
endforeach()

if (BUILD_CODEGRADE_TESTS)
  foreach(TEST_SUITE IN LISTS TEST_SUITES)
    add_executable(tests_${TEST_SUITE} tests/src/tests_${TEST_SUITE}.cpp tests/src/tests_aux.cpp)
    target_compile_options(tests_${TEST_SUITE} PUBLIC -g -Wall -Wextra -Wshadow -Wpedantic -Wdouble-promotion -Wformat=2 -Wundef -Werror)
    target_include_directories(tests_${TEST_SUITE} PUBLIC include tests/include)
    target_link_libraries(tests_${TEST_SUITE} PUBLIC gtest gtest_main pthread m)
  endforeach()
else()
  # Build a single executable with all the tests. Used during development only, not on CodeGrade.
  add_executable(run_all_tests ${SOURCES})
  target_compile_options(run_all_tests PUBLIC -g -Wall -Wextra -Wshadow -Wpedantic -Wdouble-promotion -Wformat=2 -Wundef -Werror)
  target_include_directories(run_all_tests PUBLIC include tests/include)
  target_link_libraries(run_all_tests PUBLIC gtest gtest_main pthread m)
endif()