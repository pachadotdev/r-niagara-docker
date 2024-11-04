# R Docker Images

## Description

CRAN tests packages on a number of different platforms. This repository contains
the Dockerfiles to create Docker images with a similar configuration to the
[Niagara Cluester](https://docs.scinet.utoronto.ca/index.php/Niagara_Quickstart)
and test outside the server to save the user quota for computation.

Being Docker a portable solution, these work on other hardware as well.

| Image                 | R version | OS           | Compiler | Notes            |
|---------------------- |-----------|--------------|----------|------------------|
| r-stable-ubuntu-clang | 4.4.2     | Ubuntu 22    | Clang 19 | Patched pkgload* |
| r-stable-ubuntu-gcc   | 4.4.2     | Ubuntu 22    | GCC 11   | Patched pkgload* |

These images are minimal, and these provide a non-root user ("docker") with
passwordless sudo.

I made these because I got tired of asking on Stackoverflow and receive comments
with expressions that I would not write or say to other people.

These images reflect hours of web search, try and fail, and I hope they can help
others.

## Using the images

[Here](https://github.com/pachadotdev/r-niagara-docker/blob/main/.github/workflows/r-stable-ubuntu-clang.yml) is an example of how to use the images with GitHub Actions.

## Publish the images

Note for myself: I have to login to the docker hub before I can push the images.

```
docker login
docker build -t pachadotdev/r-stable-ubuntu-clang:latest .
docker push pachadotdev/r-stable-ubuntu-clang:latest
```

Troubleshooting:

```
docker system prune -a
docker build -t r-stable-ubuntu-clang .
# docker build --no-cache -t r-stable-ubuntu-clang .
docker run -it -p 2222:22 --name ubuntuclangtest r-stable-ubuntu-clang /bin/bash
```

## Notes

Notes:

* Patched pkgload: I could not fix this error message when installing "devtools",
  so I patched "pkgload" to remove the second-order "Rcpp" dependency.

```r
> install.packages("Rcpp")
using C++ compiler: ‘Ubuntu clang version 19.1.3 (++20241031083547+ab51eccf88f5-1~exp1~20241031083703.58)’
clang++-19 -stdlib=libc++ -I"/opt/R/lib/R/include" -DNDEBUG -I../inst/include/  -I/usr/local/include    -fpic  -Wall -O3 -pedantic  -c barrier.cpp -o barrier.o
barrier.cpp:74:30: error: use of undeclared identifier 'VECTOR_PTR_RO'; did you mean
      'VECTOR_PTR'?
   74 |     return const_cast<SEXP*>(RCPP_VECTOR_PTR(x));                                                       /...
      |                              ^~~~~~~~~~~~~~~
      |                              VECTOR_PTR
../inst/include/Rcpp/r/compat.h:34:26: note: expanded from macro 'RCPP_VECTOR_PTR'
   34 | # define RCPP_VECTOR_PTR VECTOR_PTR_RO
      |                          ^
  installation of package ‘Rcpp’ had non-zero exit status
```
