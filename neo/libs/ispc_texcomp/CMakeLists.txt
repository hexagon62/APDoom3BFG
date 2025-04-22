# neo/libs/ispc_texcomp/CMakeLists.txt

cmake_minimum_required(VERSION 3.10)

# Name of the library
set(LIB_NAME ispc_texcomp)

# Find the ISPC compiler
find_program(ISPC_EXECUTABLE ispc)
if(NOT ISPC_EXECUTABLE)
    message(FATAL_ERROR "ISPC compiler not found. Please install ISPC and ensure it is in the PATH.")
endif()

# Source files
set(SOURCES
    ispc_texcomp.h
    ispc_texcomp.cpp
)

# ISPC file
set(ISPC_SOURCE kernel.ispc)
set(ISPC_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/kernel_ispc.h)

# ISPC compilation command
# Target for x86_64 (can be adjusted for other architectures)

if (MSVC)
    set(ISPC_OBJ ${CMAKE_CURRENT_SOURCE_DIR}/kernel.obj)

    add_custom_command(
        OUTPUT ${ISPC_OBJ} ${ISPC_HEADER}
        COMMAND ${ISPC_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${ISPC_SOURCE}
                -o ${ISPC_OBJ}
                -h ${ISPC_HEADER}
                --target=avx2-i32x8 --arch=x86-64
        DEPENDS ${ISPC_SOURCE}
        COMMENT "Compiling ISPC file ${ISPC_SOURCE}"
    )
else()
    # TODO: Add support for other platforms (e.g., ARM, AArch64)
    message(FATAL_ERROR "ISPC compilation for non-MSVC platforms is not yet implemented.")
endif()

# Create a static library
add_library(${LIB_NAME} STATIC
    ${SOURCES}
    ${ISPC_OBJ}
)

# Include directories
target_include_directories(${LIB_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR} # For kernel.h
)

# Ensure ISPC objects are created before the library
add_dependencies(${LIB_NAME} ${LIB_NAME}_ispc)

# Custom target to enforce dependency
add_custom_target(${LIB_NAME}_ispc
    DEPENDS ${ISPC_OBJ} ${ISPC_HEADER}
)

# Platform-specific settings (if needed)
if(MSVC)
    target_compile_options(${LIB_NAME} PRIVATE /W4)
else()
    target_compile_options(${LIB_NAME} PRIVATE -Wall -Wextra)
endif()

