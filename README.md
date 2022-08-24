# JCA Fields2Cover Package

JCA build of the [Fields2Cover](https://github.com/Fields2Cover/Fields2Cover) package. Originally forked from the `main` branch at commit [f66a150a78cbca9f7ddc7c953e436d0d94eb506f](https://github.com/Fields2Cover/Fields2Cover/commit/f66a150a78cbca9f7ddc7c953e436d0d94eb506f) (Jul 28, 2022). This package contains added features that are required for JCA's path planning. Any bug fixes should be pushed upstream.

## Build

This package uses a slightly modified version of Fields2Cover's main CMake file. The CPack variables are commented out and a JCA-Packing CMake module is added instead.

To build and package this file locally, run the following:
```shell
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build .
cpack -G DEB
```

If successfuly, a Debian package will be created in `_packages`.

## Version
The version that is used for the Debian package is set in [VERSION](./VERSION). 

### Dependencies
See [README.rst](./README.rst) for build dependencies.

## Installation
To install this package run `sudo apt install ./<package_name>.deb` with `package_name` substituted with the actual package's name. You can also run `sudo dpkg -i ./<package_name>.deb`.

To use this package within your CMake project, add the following to your CMake file:
```cmake
find_package(Fields2Cover REQUIRED PATHS /usr/share/cmake)
target_link_libraries(<<<your_package>>> Fields2Cover)
```

## Pulling from Upstream

To pull changes from [Fields2Cover](), do the following:
```shell
git checkout develop
git checkout -b upstream-changes
git remote add upstream https://github.com/Fields2Cover/Fields2Cover
git pull upstream
git merge upstream/main
git push --set-upstream origin upstream-changes
```

You can then do a PR to develop. Once you have done this once, you should only have to do the following:
```shell
git checkout upstream-changes
git merge develop
git pull upstream
git merge upstream/main
git push 
```
## Related Repos
See [Path Planner](https://bitbucket.jcaelectronics.ca/projects/JCAG/repos/pathplanner/browse)
## TODO
- JG-120 - Build other architectures
- JG-122 - Run tests and publish coverage in Jenkins build
- 