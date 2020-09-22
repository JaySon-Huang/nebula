# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License,
# attached with Common Clause Condition 1.0, found in the LICENSES directory.

set(name proxygen)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)

#set(ProxygenLibs "-lssl -lcrypto -ldl -lglog -lunwind ${extra_link_libs}")
set(ProxygenLibs "-lssl -lcrypto -ldl -lglog ${extra_link_libs}")
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    # clang requires explicitly linking to libatomic
    set(ProxygenLibs "${ProxygenLibs} -latomic")
endif()

ExternalProject_Add(
    ${name}
    URL https://github.com/facebook/proxygen/archive/v2020.01.06.00.tar.gz
    URL_HASH MD5=50e598ace7b92e05e8688e19ec81481e
    DOWNLOAD_NAME proxygen-2020-01-06.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    #PATCH_COMMAND patch -p0 < ${CMAKE_SOURCE_DIR}/patches/proxygen-2018-08-20.patch
    # CONFIGURE_COMMAND ""
    CMAKE_ARGS
        ${common_cmake_args}
        -DCMAKE_BUILD_TYPE=Release
        -DBoost_USE_STATIC_RUNTIME=ON
        -DBUILD_TESTS=OFF
    BUILD_COMMAND env PATH=${BUILDING_PATH} make -s -j${BUILDING_JOBS_NUM} -C proxygen
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND env PATH=${BUILDING_PATH} make -s -j${BUILDING_JOBS_NUM} install -C proxygen
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

# ExternalProject_Add_Step(proxygen mannual-configure
#     DEPENDEES download update patch configure
#     DEPENDERS build install
#     COMMAND env PATH=${BUILDING_PATH} ACLOCAL_PATH=${ACLOCAL_PATH} autoreconf -if
#     COMMAND
#         ${common_configure_envs}
#         "LIBS=${ProxygenLibs}"
#         ./configure
#             ${common_configure_args}
#             --disable-shared
#             --enable-static
#     WORKING_DIRECTORY ${source_dir}/proxygen
# )

ExternalProject_Add_Step(${name} clean
    EXCLUDE_FROM_MAIN TRUE
    ALWAYS TRUE
    DEPENDEES mannual-configure
    COMMAND make clean -j
    COMMAND rm -f ${BUILD_INFO_DIR}/${name}-build
    WORKING_DIRECTORY ${source_dir}/proxygen
)

ExternalProject_Add_StepTargets(${name} clean)
