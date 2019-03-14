find_package(PkgConfig)

ANTLR(INPUT Scene.g4 FLAGS "-Dlanguage=Cpp;-no-listener;-visitor" DEPENDENCIES Scene.cpp)

set(EXE_NAME ex2_imagegen)


# CMake commands copied by the CMake file for CImg

# To use PKG_CHECK_MODULES to find some optional packages
find_package(PkgConfig)

# ### CIMG related stuff
# Flags to enable fast image display, using the XSHM library.
SET(CIMG_XSHM_CCFLAGS  -Dcimg_use_xshm)

# Flags to enable screen mode switching, using the XRandr library.
SET(CIMG_XRANDR_CCFLAGS  -Dcimg_use_xrandr)

# Flags to enable native support for JPEG image files, using the JPEG library.
# ( http://www.ijg.org/ )
SET(CIMG_JPEG_CCFLAGS  -Dcimg_use_jpeg)

# Flags to enable native support for TIFF image files, using the TIFF library.
# ( http://www.libtiff.org/ )
SET(CIMG_TIFF_CCFLAGS  -Dcimg_use_tiff)

# Flags to enable native support for PNG image files, using the PNG library.
# ( http://www.libpng.org/ )
SET(CIMG_PNG_CCFLAGS  -Dcimg_use_png)

#Flags to enable OPENCV support (Camera)
# ( http://www.opencv.org/ )
SET(CIMG_OPENCV_CCFLAGS-Dcimg_use_opencv)

# Flags to enable native support for EXR image files, using the OpenEXR library.
# ( http://www.openexr.com/ )
SET(CIMG_OPENEXR_CCFLAGS  -Dcimg_use_openexr)

# Flags to enable native support for various video files, using the FFMPEG library.
# ( http://www.ffmpeg.org/ )
SET(CIMG_FFMPEG_CCFLAGS  -Dcimg_use_ffmpeg)

# Flags to enable native support of most classical image file formats, using the Magick++ library.
# ( http://www.imagemagick.org/Magick++/ )
SET(CIMG_MAGICK_CCFLAGS -Dcimg_use_magick)

# Flags to enable faster Discrete Fourier Transform computation, using the FFTW3 library
# ( http://www.fftw.org/ )
SET(CIMG_FFTW3_CCFLAGS  -Dcimg_use_fftw3)

# ### Search Additional Libraries ##########
FIND_PACKAGE(OpenCV)
FIND_PACKAGE(JPEG)
FIND_PACKAGE(TIFF)
FIND_PACKAGE(PNG)
FIND_PACKAGE(ZLIB)
FIND_PACKAGE(LAPACK)
FIND_PACKAGE(BLAS)

PKG_CHECK_MODULES(FFTW3 fftw3)
PKG_CHECK_MODULES(OPENEXR OpenEXR)
PKG_CHECK_MODULES(MAGICK Magick++)

if(NOT WIN32)
  FIND_PACKAGE(X11)
  FIND_PACKAGE(Threads REQUIRED)
endif()

# #### End of additional libraries search ##########


### Configure Paths according to detected packages
if(TIFF_FOUND)
  get_filename_component(TIFF_LIB_DIRS ${TIFF_LIBRARIES} PATH)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_TIFF_CCFLAGS}")
  link_directories(${TIFF_LIB_DIRS})
  include_directories(${TIFF_INCLUDE_DIR})
  SET(SYSTEM_LIBS ${SYSTEM_LIBS} ${TIFF_LIBRARIES})
endif()

if(JPEG_FOUND)
  get_filename_component(JPEG_LIB_DIRS ${JPEG_LIBRARIES} PATH)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_JPEG_CCFLAGS}")
  link_directories(${JPEG_LIB_DIRS})
  include_directories(${JPEG_INCLUDE_DIR})
  SET(SYSTEM_LIBS ${SYSTEM_LIBS} ${JPEG_LIBRARIES})
endif()

if (ZLIB_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_ZLIB_CCFLAGS}")
  link_directories(${ZLIB_LIB_DIRS})
  include_directories(${ZLIB_INCLUDE_DIR})
  SET(SYSTEM_LIBS ${SYSTEM_LIBS} ${ZLIB_LIBRARIES})

  # PNG requires ZLIB
  if(PNG_FOUND)
    SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_PNG_CCFLAGS}")
    link_directories(${PNG_LIB_DIRS})
    include_directories(${PNG_INCLUDE_DIR} )
    SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${PNG_LIBRARIES} )
  endif()
endif()

if(FFTW3_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_FFTW3_CCFLAGS}")
  link_directories( ${FFTW3_LIBRARY_DIRS} )
  include_directories( ${FFTW3_INCLUDE_DIRS} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${FFTW3_LIBRARIES} )
endif()

if(OPENEXR_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_OPENEXR_CCFLAGS}")
  link_directories( ${OPENEXR_LIBRARY_DIRS} )
  include_directories( ${OPENEXR_INCLUDE_DIRS} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${OPENEXR_LIBRARIES} )
endif()

if(MAGICK_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_MAGICK_CCFLAGS}")
  link_directories( ${MAGICK_LIBRARY_DIRS} )
  include_directories( ${MAGICK_INCLUDE_DIRS} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${MAGICK_LIBRARIES} )
endif()

if( LIBAVCODEC_FOUND  AND LIBAVFORMAT_FOUND AND LIBSWSCALE_FOUND AND LIBAVUTIL_FOUND )
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_FFMPEG_CCFLAGS}")
  link_directories( ${LIBAVFORMAT_LIBRARY_DIRS} )
  link_directories( ${LIBAVCODEC_LIBRARY_DIRS} )
  link_directories( ${LIBSWSCALE_LIBRARY_DIRS} )
  link_directories( ${LIBAVUTIL_LIBRARY_DIRS} )
  include_directories( ${LIBAVFORMAT_INCLUDE_DIRS} ${LIBAVFORMAT_INCLUDE_DIRS}/libavformat)
  include_directories( ${LIBAVCODEC_INCLUDE_DIRS} ${LIBAVCODEC_INCLUDE_DIRS}/libavcodec )
  include_directories( ${LIBSWSCALE_INCLUDE_DIRS} ${LIBSWSCALE_INCLUDE_DIRS}/libswscale)
  include_directories( ${LIBAVUTIL_INCLUDE_DIRS} ${LIBAVUTIL_INCLUDE_DIRS}/libavutil )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${LIBAVFORMAT_LIBRARIES} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${LIBAVCODEC_LIBRARIES} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${LIBSWSCALE_LIBRARIES} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${LIBAVUTIL_LIBRARIES} )
endif()

if(NOT APPLE)
  if(NOT WIN32)
    if(X11_FOUND)
      SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_XSHM_CCFLAGS} ${CIMG_XRANDR_CCFLAGS}")
      SET(SYSTEM_LIBS ${SYSTEM_LIBS} Xext Xrandr)
    endif()
  endif(NOT WIN32)
endif(NOT APPLE)

if(X11_FOUND)
  link_directories(${X11_LIB_DIRS})
  include_directories(${X11_INCLUDE_DIR})
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${X11_LIBRARIES} )
endif()

if (NOT WIN32)
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${CMAKE_THREAD_LIBS_INIT} )
endif()

if( WIN32)
  SET( SYSTEM_LIBS  ${SYSTEM_LIBS}  gdi32 )
endif()

if (OpenCV_FOUND)
  message("OpenCV Found")
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_OPENCV_CCFLAGS}")
  include_directories(${OpenCV_INCLUDE_DIRS})
  link_directories(${OpenCV_LIB_DIRS})
  SET( SYSTEM_LIBS  ${SYSTEM_LIBS}  ${OpenCV_LIBS} )
endif()

if(LAPACK_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_LAPACK_CCFLAGS}")
  link_directories( ${LAPACK_LIBRARY_DIRS} )
  include_directories( ${LAPACK_INCLUDE_DIRS} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${LAPACK_LIBRARIES} )
endif()

if(BLAS_FOUND)
  SET(CIMG_CFLAGS "${CIMG_CFLAGS} ${CIMG_BLAS_CCFLAGS}")
  link_directories( ${BLAS_LIBRARY_DIRS} )
  include_directories( ${BLAS_INCLUDE_DIRS} )
  SET( SYSTEM_LIBS ${SYSTEM_LIBS} ${BLAS_LIBRARIES} )
endif()

# Add CIMG Flags to Compilation Flags
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CIMG_CFLAGS}")

# CMake commands for this specific project start here

# to disable some warnings for CImg
if (NOT WIN32)
  set(CMAKE_CXX_FLAGS "-Wdeprecated -Wno-attributes" )
endif()

if (APPLE)
  set(CMAKE_CXX_FLAGS "-Wdeprecated -std=c++11" )
endif()

if (MSVC)
  set(CMAKE_CXX_FLAGS "/EHsc /wd4127 /wd4311 /wd4312 /wd4512 /wd4571 /wd4640 /wd4706 /wd4710 /wd4800 /wd4804 /wd4820 /wd4996")
endif()

#-------------------------------------------------------------------------------

set(GENERATED_SRC
  ${CMAKE_CURRENT_BINARY_DIR}/SceneLexer.cpp 
  ${CMAKE_CURRENT_BINARY_DIR}/SceneParser.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/SceneBaseVisitor.cpp   
  ${CMAKE_CURRENT_BINARY_DIR}/SceneVisitor.cpp   
 )

#foreach( src_file ${antlr4-tutorial-GENERATED_SRC} )
#      set_source_files_properties(
#          ${src_file}
#          PROPERTIES
#          GENERATED TRUE
#          )
#endforeach(src_file ${antlr4-tutorial-GENERATED_SRC} )

add_executable(${EXE_NAME}
  antlr.cpp
  ImageVisitor.cpp
  SceneElems.cpp
  ${GENERATED_SRC}
)

target_compile_definitions(${EXE_NAME} PRIVATE
  # required if linking to static library
  -DANTLR4CPP_STATIC
)

target_include_directories(${EXE_NAME} SYSTEM PRIVATE
  ${ANTLR4_INCLUDE_DIRS}
  ${ANTLR4_INCLUDE_DIRS}/misc
  ${ANTLR4_INCLUDE_DIRS}/atn
  ${ANTLR4_INCLUDE_DIRS}/dfa
  ${ANTLR4_INCLUDE_DIRS}/tree
  ${ANTLR4_INCLUDE_DIRS}/support
  # Include source files and the generated files
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/libs
)

target_link_libraries(${EXE_NAME} PRIVATE ${ANTLR4_LIBS} ${SYSTEM_LIBS})

# copy the input file next to the generated executable
add_custom_command(TARGET ${EXE_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  "${CMAKE_CURRENT_SOURCE_DIR}/input.scene"
  $<TARGET_FILE_DIR:${EXE_NAME}>)