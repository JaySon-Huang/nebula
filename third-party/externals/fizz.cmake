#https://github.com/facebookincubator/fizz/archive/v2020.01.06.00.tar.gz
set(name fizz)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/facebookincubator/fizz/archive/v2020.01.06.00.tar.gz
    URL_HASH MD5=79fb75375702c6db7ab186b81eee31c8
    DOWNLOAD_NAME fizz-2020-01-06.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    SOURCE_SUBDIR fizz
    CMAKE_ARGS
        ${common_cmake_args}
        -DCMAKE_BUILD_TYPE=Release
        -DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR}
        -DBoost_USE_STATIC_RUNTIME=ON
        -DBUILD_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
    BUILD_IN_SOURCE 1
)

ExternalProject_Add_Step(${name} clean
    EXCLUDE_FROM_MAIN TRUE
    ALWAYS TRUE
    DEPENDEES configure
    COMMAND make clean -j
    COMMAND rm -f ${BUILD_INFO_DIR}/${name}-build
    WORKING_DIRECTORY ${source_dir}
)

ExternalProject_Add_StepTargets(${name} clean)
