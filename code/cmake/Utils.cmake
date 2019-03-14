# ┌─────────────┐
# │ ANTLR       │
# └─────────────┘

find_package(Java REQUIRED) 
message("Java_JAVA_EXECUTABLE = ${Java_JAVA_EXECUTABLE}")

# As of CMake 3.5, cmake_parse_arguments becomes a builtin command (written in C++ instead of CMake)
# include(CMakeParseArguments) is no longer required but, for now, the file CMakeParseArguments.cmake is kept empty for compatibility.
include(CMakeParseArguments)

# Function
#   ANTLR(INPUT <input> (DEPENDENCIES <dependencies>))
#
# Description:
#   Take an ANTLR file and produce a CMake rule to generate the corresponding
#   C++ files.
#
# Notes:
#   The ANTLR file path must be relative to ${CMAKE_CURRENT_SOURCE_DIR}
#
# Example:
#   ANTLR(INPUT MyLexer.g4)
#   ANTLR(INPUT MyParser.g4 DEPENDENCIES MyLexer.cpp)
function(ANTLR)
  # see https://cliutils.gitlab.io/modern-cmake/chapters/basics/functions.html
  set(options DEPENDENCIES)
  set(oneValueArgs INPUT)
  set(multiValueArgs FLAGS)
  #
  cmake_parse_arguments(
    ARGUMENTS # prefix of output variables
    "${options}" # list of names of the boolean arguments (only defined ones will be true)
    "${oneValueArgs}" # list of names of mono-valued arguments
    "${multiValueArgs}" # list of names of multi-valued arguments (output variables are lists)
    ${ARGN} # arguments of the function to parse, here we take the all original ones
  )
  #
  set(source ${ARGUMENTS_INPUT})
  #
  set(flags ${ARGUMENTS_FLAGS})
  #
  set(dependencies "")
  if(ARGUMENTS_DEPENDENCIES)
    set(dependencies ${ARGUMENTS_UNPARSED_ARGUMENTS})
  endif()
  #
  message("Provided ARGN are:")
  foreach(src ${ARGN})
      message("- ${src}")
  endforeach(src)
  message("dependencies=${dependencies}")
  message("source=${source}")
  message("flags=${flags}")
  #
  if(NOT ARGUMENTS_INPUT)
    message(FATAL_ERROR "You must provide ARGUMENTS_INPUT")
  endif()
  if(NOT ARGUMENTS_FLAGS)
    message(FATAL_ERROR "You must provide ARGUMENTS_FLAGS")
  endif()
  #
  get_filename_component(source_filename ${CMAKE_CURRENT_SOURCE_DIR}/${source} NAME_WE)
  get_filename_component(source_src_dir  ${CMAKE_CURRENT_SOURCE_DIR}/${source} DIRECTORY)
  get_filename_component(source_gen_dir  ${CMAKE_CURRENT_BINARY_DIR}/${source} DIRECTORY)
  #
  add_custom_command(
    DEPENDS
      ${source_src_dir}/${source_filename}.g4
      ${dependencies}
    OUTPUT
      ${source_gen_dir}/${source_filename}.h
      ${source_gen_dir}/${source_filename}.cpp
      ${source_gen_dir}/${source_filename}.interp
      ${source_gen_dir}/${source_filename}.tokens
    COMMAND
      ${Java_JAVA_EXECUTABLE} # from https://cmake.org/cmake/help/v3.5/module/FindJava.html
    ARGS
      -jar ${ANTLR_EXECUTABLE}
      ${ARGUMENTS_FLAGS}
      -o ${source_gen_dir}
      ${source_src_dir}/${source_filename}.g4
  )
  set(output ${source_gen_dir}/${source_filename}.cpp)
endfunction()