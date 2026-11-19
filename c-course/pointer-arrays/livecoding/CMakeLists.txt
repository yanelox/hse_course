cmake_minimum_required(VERSION 3.24)
project(pointer_arrays LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(USE_STARTER "Build with starter.c instead of solutions.c" OFF)
if(USE_STARTER)
    add_library(array_tasks STATIC starter.c)
else()
    add_library(array_tasks STATIC solutions.c)
endif()

add_executable(matmul_bench matmul_bench.c)
target_link_libraries(matmul_bench PRIVATE array_tasks)
add_custom_target(matmul_demo
    COMMAND $<TARGET_FILE:matmul_bench> 512
    COMMAND $<TARGET_FILE:matmul_bench> 1000
    COMMAND $<TARGET_FILE:matmul_bench> 1024
    DEPENDS matmul_bench
    USES_TERMINAL
    VERBATIM)

include(CTest)
if(BUILD_TESTING)
    find_package(GTest QUIET)
    if(NOT TARGET GTest::gtest_main)
        include(FetchContent)
        set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
        FetchContent_Declare(googletest
            URL https://codeload.github.com/google/googletest/tar.gz/refs/tags/v1.16.0
            URL_HASH SHA256=78c676fc63881529bf97bf9d45948d905a66833fbfa5318ea2cd7478cb98f399)
        FetchContent_MakeAvailable(googletest)
    endif()

    add_executable(array_tests tests.cpp test_bridge.c)
    target_link_libraries(array_tests PRIVATE array_tasks GTest::gtest_main)
    include(GoogleTest)
    gtest_discover_tests(array_tests DISCOVERY_MODE PRE_TEST)
endif()
