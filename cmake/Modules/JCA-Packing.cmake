# these are cache variables, so they could be overwritten with -D,
set(CPACK_PACKAGE_NAME JCAFields2Cover
    CACHE STRING "The resulting package name"
)
# which is useful in case of packing only selected components instead of the whole thing
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "JCA Version of Fields2Cover."
    CACHE STRING "Package description for the package metadata"
)
set(CPACK_PACKAGE_VENDOR "JCA Technologies")

set(CPACK_VERBATIM_VARIABLES YES)

set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CPACK_PACKAGE_NAME})
set(CPACK_OUTPUT_FILE_PREFIX "${CMAKE_SOURCE_DIR}/_packages")

set(CPACK_STRIP_FILES YES)

# https://stackoverflow.com/questions/47066115/cmake-get-version-from-multiline-text-file
file(READ "VERSION" ver)
string(REGEX MATCH "VERSION_MAJOR=([0-9]*)" _ ${ver})
set(CPACK_PACKAGE_VERSION_MAJOR ${CMAKE_MATCH_1})

string(REGEX MATCH "VERSION_MINOR=([0-9]*)" _ ${ver})
set(CPACK_PACKAGE_VERSION_MINOR ${CMAKE_MATCH_1})

string(REGEX MATCH "VERSION_PATCH=([0-9]*)" _ ${ver})
set(CPACK_PACKAGE_VERSION_PATCH ${CMAKE_MATCH_1})

if (DEFINED ENV{BUILD_NUMBER})
    set(VERSION_STRING_BUILD_NUMBER $ENV{BUILD_NUMBER})
    message("Hello  ${VERSION_STRING_BUILD_NUMBER}")
else()
    set(VERSION_STRING_BUILD_NUMBER "99999")
endif()

message("version: ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH} build_number: ${VERSION_STRING_BUILD_NUMBER}")

set(CPACK_PACKAGE_CONTACT "kurtis.gibson@jcatechnologies.com")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Kurtis Gibson <${CPACK_PACKAGE_CONTACT}>")

set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.rst")

set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64)
# package name for deb
# if set, then instead of some-application-0.9.2-Linux.deb
# you'll get some-application_0.9.2_amd64.deb (note the underscores too)
set(CPACK_DEBIAN_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}+b${VERSION_STRING_BUILD_NUMBER}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}.deb")

# if you want every group to have its own package,
# although the same happens if this is not sent (so it defaults to ONE_PER_GROUP)
# and CPACK_DEB_COMPONENT_INSTALL is set to YES
set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)#ONE_PER_GROUP)
# without this you won't be able to pack only specified component
set(CPACK_DEB_COMPONENT_INSTALL YES)
set(CPACK_SOURCE_IGNORE_FILES .git dist .*build.* \\\\.DS_Store .dockerignore)

include(CPack)