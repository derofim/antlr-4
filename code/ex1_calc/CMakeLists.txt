ANTLR(INPUT MyLexer.g4 FLAGS "-Dlanguage=Cpp;-no-listener;-no-visitor")
ANTLR(INPUT MyParser.g4 FLAGS "-Dlanguage=Cpp;-no-listener;-no-visitor" DEPENDENCIES MyLexer.cpp)

set(EXE_NAME ex_calc)

#-------------------------------------------------------------------------------

add_executable(${EXE_NAME}
  main.cpp
  MyLexer.cpp
  MyParser.cpp
  analysis.cpp
)

target_compile_definitions(${EXE_NAME} PRIVATE
  # required if linking to static library
  -DANTLR4CPP_STATIC
)

target_include_directories(${EXE_NAME} SYSTEM PRIVATE
  ${ANTLR4_INCLUDE_DIRS}
  # Include source files and the generated files
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(${EXE_NAME} PRIVATE ${ANTLR4_LIBS})