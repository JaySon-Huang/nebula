# - Try to find Fbthrift includes dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(Fbthrift)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
# Variables defined by this module:
#
#  Fbthrift_FOUND            System has fbthrift, thrift1 and include and lib dirs found.
#  Fbthrift_INCLUDE_DIR      The fbthrift includes directories.
#  Fbthrift_LIBRARIES        The fbthrift libraries.
#  Fbthrift_BIN              The fbthrift binary.

find_package(OpenSSL REQUIRED)

find_path(Fbthrift_INCLUDE_DIR NAMES thrift)
find_library(Fbthrift_CORE_LIBRARY NAMES thrift-core)
find_library(Fbthrift_CPP2_LIBRARY NAMES thriftcpp2)
find_library(Fbthrift_PROTOCOL_LIBRARY NAMES thriftprotocol)
find_library(Fbthrift_Z_LIBRARY NAMES thriftforzen2)
set(Fbthrift_LIBRARIES
    ${Fbthrift_CORE_LIBRARY}
    ${Fbthrift_CPP2_LIBRARY}
    ${Fbthrift_PROTOCOL_LIBRARY}
    ${Fbthrift_Z_LIBRARY}
    ${OPENSSL_LIBRARIES}
)
find_program(Fbthrift_BIN NAMES thrift1)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    Fbthrift DEFAULT_MSG Fbthrift_INCLUDE_DIR Fbthrift_LIBRARIES)

mark_as_advanced(Fbthrift_INCLUDE_DIR Fbthrift_LIBRARIES Fbthrift_FOUND)

if(NOT Fbthrift_FOUND)
    message(FATAL_ERROR "Fbthrift doesn't exist")
else()
    message(STATUS "FBTHRIFT: ${Fbthrift_INCLUDE_DIR}")
endif()


