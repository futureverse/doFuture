# STARRS ()

* GitHub: <https://github.com/futureverse/doFuture>
* Email: <mailto:henrikb@braju.com>

Run `revdepcheck::revdep_details(, "STARRS")` for more info

## Error before installation

### Devel

```
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c knn_euclid_brute.cpp -o knn_euclid_brute.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c mst_euclid_brute.cpp -o mst_euclid_brute.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c knn_euclid_kdtree.cpp -o knn_euclid_kdtree.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c mst_euclid_kdtree.cpp -o mst_euclid_kdtree.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppFastmst.cpp -o RcppFastmst.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppExports.cpp -o RcppExports.o
g++ -std=gnu++20 -shared -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -L/usr/local/lib64 -o quitefastmst.so knn_euclid_brute.o mst_euclid_brute.o knn_euclid_kdtree.o mst_euclid_kdtree.o RcppFastmst.o RcppExports.o -fopenmp -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -lR
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppDeadwood.cpp -o RcppDeadwood.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppOldmst.cpp -o RcppOldmst.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppExports.cpp -o RcppExports.o
g++ -std=gnu++20 -shared -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -L/usr/local/lib64 -o deadwood.so RcppDeadwood.o RcppOldmst.o RcppExports.o -fopenmp -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -lR


* installing *binary* package ‘backports’ ...
* package ‘backports’ successfully unpacked and SHA256 sums checked
* DONE (backports)
* installing *binary* package ‘base64enc’ ...
* package ‘base64enc’ successfully unpacked and SHA256 sums checked
* DONE (base64enc)
* installing *binary* package ‘bit’ ...
* package ‘bit’ successfully unpacked and SHA256 sums checked
* DONE (bit)
* installing *binary* package ‘boot’ ...
...
* installing *binary* package ‘haven’ ...
* package ‘haven’ successfully unpacked and SHA256 sums checked
* DONE (haven)
* installing *binary* package ‘DescTools’ ...
* package ‘DescTools’ successfully unpacked and SHA256 sums checked
* DONE (DescTools)

The downloaded source packages are in
	‘/scratch/hb/RtmpxYwt2m/downloaded_packages’
Error in loadNamespace(x) : there is no package called ‘callr’


```
### CRAN

```
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c knn_euclid_brute.cpp -o knn_euclid_brute.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c mst_euclid_brute.cpp -o mst_euclid_brute.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c knn_euclid_kdtree.cpp -o knn_euclid_kdtree.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c mst_euclid_kdtree.cpp -o mst_euclid_kdtree.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppFastmst.cpp -o RcppFastmst.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DQUITEFASTMST_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppExports.cpp -o RcppExports.o
g++ -std=gnu++20 -shared -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -L/usr/local/lib64 -o quitefastmst.so knn_euclid_brute.o mst_euclid_brute.o knn_euclid_kdtree.o mst_euclid_kdtree.o RcppFastmst.o RcppExports.o -fopenmp -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -lR
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppDeadwood.cpp -o RcppDeadwood.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppOldmst.cpp -o RcppOldmst.o
g++ -std=gnu++20 -I"/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/include" -DNDEBUG  -I'/scratch/hb/revdepcheck/doFuture/library/STARRS/Rcpp/include' -I/usr/local/include   -fopenmp -DDEADWOOD_R -Isrc/ -I../src/ -fpic  -g -O2   -c RcppExports.cpp -o RcppExports.o
g++ -std=gnu++20 -shared -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -L/usr/local/lib64 -o deadwood.so RcppDeadwood.o RcppOldmst.o RcppExports.o -fopenmp -L/wynton/home/cbi/shared/software/CBI/_rocky8/R-4.6.1-gcc13/lib64/R/lib -lR


* installing *binary* package ‘backports’ ...
* package ‘backports’ successfully unpacked and SHA256 sums checked
* DONE (backports)
* installing *binary* package ‘base64enc’ ...
* package ‘base64enc’ successfully unpacked and SHA256 sums checked
* DONE (base64enc)
* installing *binary* package ‘bit’ ...
* package ‘bit’ successfully unpacked and SHA256 sums checked
* DONE (bit)
* installing *binary* package ‘boot’ ...
...
* installing *binary* package ‘haven’ ...
* package ‘haven’ successfully unpacked and SHA256 sums checked
* DONE (haven)
* installing *binary* package ‘DescTools’ ...
* package ‘DescTools’ successfully unpacked and SHA256 sums checked
* DONE (DescTools)

The downloaded source packages are in
	‘/scratch/hb/RtmpxYwt2m/downloaded_packages’
Error in loadNamespace(x) : there is no package called ‘callr’


```
# WeightedCluster ()

* GitHub: <https://github.com/futureverse/doFuture>
* Email: <mailto:henrikb@braju.com>

Run `revdepcheck::revdep_details(, "WeightedCluster")` for more info

## Error before installation

### Devel

```
Creating a generic function for ‘na.pass’ from package ‘stats’ in package ‘modeltools’
Creating a generic function from function ‘MEapply’ in package ‘modeltools’


* installing *binary* package ‘base64enc’ ...
* package ‘base64enc’ successfully unpacked and SHA256 sums checked
* DONE (base64enc)
* installing *binary* package ‘boot’ ...
* package ‘boot’ successfully unpacked and SHA256 sums checked
* DONE (boot)
* installing *binary* package ‘Cairo’ ...
* package ‘Cairo’ successfully unpacked and SHA256 sums checked
* DONE (Cairo)
* installing *binary* package ‘class’ ...
...
* installing *binary* package ‘TraMineR’ ...
* package ‘TraMineR’ successfully unpacked and SHA256 sums checked
* DONE (TraMineR)
* installing *binary* package ‘vegclust’ ...
* package ‘vegclust’ successfully unpacked and SHA256 sums checked
* DONE (vegclust)

The downloaded source packages are in
	‘/scratch/hb/RtmpMFbQEK/downloaded_packages’
Error in loadNamespace(x) : there is no package called ‘callr’


```
### CRAN

```
Creating a generic function for ‘na.pass’ from package ‘stats’ in package ‘modeltools’
Creating a generic function from function ‘MEapply’ in package ‘modeltools’


* installing *binary* package ‘base64enc’ ...
* package ‘base64enc’ successfully unpacked and SHA256 sums checked
* DONE (base64enc)
* installing *binary* package ‘boot’ ...
* package ‘boot’ successfully unpacked and SHA256 sums checked
* DONE (boot)
* installing *binary* package ‘Cairo’ ...
* package ‘Cairo’ successfully unpacked and SHA256 sums checked
* DONE (Cairo)
* installing *binary* package ‘class’ ...
...
* installing *binary* package ‘TraMineR’ ...
* package ‘TraMineR’ successfully unpacked and SHA256 sums checked
* DONE (TraMineR)
* installing *binary* package ‘vegclust’ ...
* package ‘vegclust’ successfully unpacked and SHA256 sums checked
* DONE (vegclust)

The downloaded source packages are in
	‘/scratch/hb/RtmpMFbQEK/downloaded_packages’
Error in loadNamespace(x) : there is no package called ‘callr’


```
