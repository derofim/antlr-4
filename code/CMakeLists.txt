# minimum required CMAKE version
CMAKE_MINIMUM_REQUIRED(VERSION 3.7 FATAL_ERROR)

project(antler)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# compiler must be 11 or 14
# set(CMAKE_CXX_STANDARD 14)

find_package(ANTLR REQUIRED)

if(NOT ANTLR_EXECUTABLE)
  message(FATAL_ERROR "ANTLR_EXECUTABLE not found")
else()
  message("ANTLR_EXECUTABLE = ${ANTLR_EXECUTABLE}")
  message("ANTLR4_LIBS = ${ANTLR4_LIBS}")
  message("ANTLR4_INCLUDE_DIRS = ${ANTLR4_INCLUDE_DIRS}")
endif()

include(cmake/Utils.cmake)

# using /MD flag for antlr4_runtime (for Visual C++ compilers only)
#set(ANTLR4_WITH_STATIC_CRT OFF)


#ANTLR(INPUT MyLexer.g4)
#ANTLR(INPUT MyParser.g4 DEPENDENCIES MyLexer.cpp)

#-------------------------------------------------------------------------------

add_subdirectory(ex1_calc)

add_subdirectory(ex2_imagegen)

## set variable pointing to the antlr tool that supports C++
## this is not required if the jar file can be found under PATH environment
## set(ANTLR_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/antlr-4.7.1-complete.jar)
#
## add macros to generate ANTLR Cpp code from grammar
#find_package(ANTLR REQUIRED)
#antlr_target(Calculator ${CMAKE_SOURCE_DIR}/grammar/Calculator.g4
#    LISTENER
#    OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/src/generated
#    )
#
#include_directories(${ANTLR_Calculator_OUTPUT_DIR})
#
##add_custom_target("antlr4cpp_generation_${antlr4cpp_project_namespace}"
#  #COMMAND
#  #${CMAKE_COMMAND} -E make_directory ${ANTLR4CPP_GENERATED_SRC_DIR}
#  #COMMAND
#  #"${Java_JAVA_EXECUTABLE}" -jar "${ANTLR4CPP_JAR_LOCATION}" -Werror -Dlanguage=Cpp -listener -visitor -o "${ANTLR4CPP_GENERATED_SRC_DIR}/${antlr4cpp_project_namespace}" -package ${antlr4cpp_project_namespace} "${antlr4cpp_grammar_lexer}" "${antlr4cpp_grammar_parser}"
#  #WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
#  #DEPENDS "${antlr4cpp_grammar_lexer}" "${antlr4cpp_grammar_parser}"
##)
#
#add_executable(calc
#    ${CMAKE_SOURCE_DIR}/src/main.cpp
#    ${CMAKE_SOURCE_DIR}/src/CalculatorInterpreter.cpp
#    ${ANTLR_Calculator_CXX_OUTPUTS})
#target_link_libraries(calc antlr4_static)