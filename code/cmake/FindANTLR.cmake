find_package(Java REQUIRED COMPONENTS Runtime)

file(GLOB ANTLR_EXECUTABLE_FILELIST
LIST_DIRECTORIES false
ABSOLUTE "/usr/lib"
"antlr*.jar")

if(NOT ANTLR_EXECUTABLE)
  find_program(ANTLR_EXECUTABLE
               NAMES antlr.jar antlr4.jar antlr-4.jar ${ANTLR_EXECUTABLE_FILELIST} ${ANTLR4_HOME}
               HINTS /usr/lib /usr/bin /usr/local/lib /usr/local/bin)
endif()


# Find the lua header
FIND_PATH(ANTLR4_INCLUDE_DIRS ANTLRInputStream.h
  HINTS
  $ENV{ANTLR4_CPP_RUNTIME_HOME}
  $ENV{ANTLR4_CPP_RUNTIME_HOME}/include
  $ENV{ANTLR4_HOME}
  $ENV{ANTLR4_HOME}/include
  PATHS
  ~/include
  ~/Library/Frameworks
  /Library/Frameworks
  /usr
  /usr/include
  /usr/local
  /usr/local/include
  /usr/local/include/antlr4-runtime
  /usr/local/homebrew/include
  /sw # Fink
  /opt
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt/include
  /opt/local/include
  /include
)


# Find the lua library
FIND_LIBRARY(ANTLR4_LIBS 
  NAMES libantlr4-runtime libantlr4-runtime.a libantlr4-runtime.so libantlr4-runtime.dll libantlr4-runtime.lib antlr4_static
  HINTS
  $ENV{ANTLR4_CPP_RUNTIME_HOME}
  $ENV{ANTLR4_LIB_HOME}
  $ENV{ANTLR4_HOME}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr
  /usr/local
  /sw
  /opt
  /opt/local
  /opt/csw
)

#/usr/local/include/antlr4-runtime

#if(ANTLR_EXECUTABLE AND Java_JAVA_EXECUTABLE)
#  execute_process(
#      COMMAND ${Java_JAVA_EXECUTABLE} -jar ${ANTLR_EXECUTABLE}
#      OUTPUT_VARIABLE ANTLR_COMMAND_OUTPUT
#      ERROR_VARIABLE ANTLR_COMMAND_ERROR
#      RESULT_VARIABLE ANTLR_COMMAND_RESULT
#      OUTPUT_STRIP_TRAILING_WHITESPACE)
#
#  if(ANTLR_COMMAND_RESULT EQUAL 0)
#    string(REGEX MATCH "Version [0-9]+(\\.[0-9])*" ANTLR_VERSION ${ANTLR_COMMAND_OUTPUT})
#    string(REPLACE "Version " "" ANTLR_VERSION ${ANTLR_VERSION})
#  else()
#    message(
#        SEND_ERROR
#        "Command '${Java_JAVA_EXECUTABLE} -jar ${ANTLR_EXECUTABLE}' "
#        "failed with the output '${ANTLR_COMMAND_ERROR}'")
#  endif()
#
#  macro(ANTLR_TARGET Name InputFile)
#    set(ANTLR_OPTIONS LEXER PARSER LISTENER VISITOR)
#    set(ANTLR_ONE_VALUE_ARGS PACKAGE OUTPUT_DIRECTORY DEPENDS_ANTLR)
#    set(ANTLR_MULTI_VALUE_ARGS COMPILE_FLAGS DEPENDS)
#    cmake_parse_arguments(ANTLR_TARGET
#                          "${ANTLR_OPTIONS}"
#                          "${ANTLR_ONE_VALUE_ARGS}"
#                          "${ANTLR_MULTI_VALUE_ARGS}"
#                          ${ARGN})
#
#    set(ANTLR_${Name}_INPUT ${InputFile})
#
#    get_filename_component(ANTLR_INPUT ${InputFile} NAME_WE)
#
#    if(ANTLR_TARGET_OUTPUT_DIRECTORY)
#      set(ANTLR_${Name}_OUTPUT_DIR ${ANTLR_TARGET_OUTPUT_DIRECTORY})
#    else()
#      set(ANTLR_${Name}_OUTPUT_DIR
#          ${CMAKE_CURRENT_BINARY_DIR}/antlr4cpp_generated_src/${ANTLR_INPUT})
#    endif()
#
#    unset(ANTLR_${Name}_CXX_OUTPUTS)
#
#    if((ANTLR_TARGET_LEXER AND NOT ANTLR_TARGET_PARSER) OR
#       (ANTLR_TARGET_PARSER AND NOT ANTLR_TARGET_LEXER))
#      list(APPEND ANTLR_${Name}_CXX_OUTPUTS
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}.cpp)
#      set(ANTLR_${Name}_OUTPUTS
#          ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}.interp
#          ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}.tokens)
#    else()
#      list(APPEND ANTLR_${Name}_CXX_OUTPUTS
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Lexer.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Lexer.cpp
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Parser.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Parser.cpp)
#      list(APPEND ANTLR_${Name}_OUTPUTS
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Lexer.interp
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Lexer.tokens)
#    endif()
#
#    if(ANTLR_TARGET_LISTENER)
#      list(APPEND ANTLR_${Name}_CXX_OUTPUTS
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}BaseListener.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}BaseListener.cpp
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Listener.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Listener.cpp)
#      list(APPEND ANTLR_TARGET_COMPILE_FLAGS -listener)
#    endif()
#
#    if(ANTLR_TARGET_VISITOR)
#      list(APPEND ANTLR_${Name}_CXX_OUTPUTS
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}BaseVisitor.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}BaseVisitor.cpp
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Visitor.h
#           ${ANTLR_${Name}_OUTPUT_DIR}/${ANTLR_INPUT}Visitor.cpp)
#      list(APPEND ANTLR_TARGET_COMPILE_FLAGS -visitor)
#    endif()
#
#    if(ANTLR_TARGET_PACKAGE)
#      list(APPEND ANTLR_TARGET_COMPILE_FLAGS -package ${ANTLR_TARGET_PACKAGE})
#    endif()
#
#    list(APPEND ANTLR_${Name}_OUTPUTS ${ANTLR_${Name}_CXX_OUTPUTS})
#
#    if(ANTLR_TARGET_DEPENDS_ANTLR)
#      if(ANTLR_${ANTLR_TARGET_DEPENDS_ANTLR}_INPUT)
#        list(APPEND ANTLR_TARGET_DEPENDS
#             ${ANTLR_${ANTLR_TARGET_DEPENDS_ANTLR}_INPUT})
#        list(APPEND ANTLR_TARGET_DEPENDS
#             ${ANTLR_${ANTLR_TARGET_DEPENDS_ANTLR}_OUTPUTS})
#      else()
#        message(SEND_ERROR
#                "ANTLR target '${ANTLR_TARGET_DEPENDS_ANTLR}' not found")
#      endif()
#    endif()
#
#    add_custom_command(
#        OUTPUT ${ANTLR_${Name}_OUTPUTS}
#        COMMAND ${Java_JAVA_EXECUTABLE} -jar ${ANTLR_EXECUTABLE}
#                ${InputFile}
#                -o ${ANTLR_${Name}_OUTPUT_DIR}
#                -no-listener
#                -Dlanguage=Cpp
#                ${ANTLR_TARGET_COMPILE_FLAGS}
#        DEPENDS ${InputFile}
#                ${ANTLR_TARGET_DEPENDS}
#        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#        COMMENT "Building ${Name} with ANTLR ${ANTLR_VERSION}")
#  endmacro(ANTLR_TARGET)
#
#endif(ANTLR_EXECUTABLE AND Java_JAVA_EXECUTABLE)
#
#include(FindPackageHandleStandardArgs)
#find_package_handle_standard_args(
#    ANTLR
#    REQUIRED_VARS ANTLR_EXECUTABLE Java_JAVA_EXECUTABLE
#    VERSION_VAR ANTLR_VERSION)
