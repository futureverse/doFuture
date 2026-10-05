# baskexact (1.0.1)

* GitHub: <https://github.com/lbau7/baskexact>
* Email: <mailto:baumann@imbi.uni-heidelberg.de>
* GitHub mirror: <https://github.com/cran/baskexact>

Run `revdepcheck::revdep_details(, "baskexact")` for more info

## In both

*   checking dependencies in R code ... NOTE
     ```
     Namespace in Imports field not imported from: ‘ggplot2’
       All declared Imports should be used.
     ```

# CrcBiomeScreen (1.0.0)

* GitHub: <https://github.com/omicsForestry/CrcBiomeScreen>
* Email: <mailto:ngzh5554@leeds.ac.uk>

Run `revdepcheck::revdep_details(, "CrcBiomeScreen")` for more info

## In both

*   checking for non-standard things in the check directory ... NOTE
     ```
     Found the following files/directories:
       ‘roc.curve.rf.RF_TSS_toydata_Validation.pdf’
     ```

# envi (1.0.1)

* GitHub: <https://github.com/lance-waller-lab/envi>
* Email: <mailto:ian.buller@alumni.emory.edu>
* GitHub mirror: <https://github.com/cran/envi>

Run `revdepcheck::revdep_details(, "envi")` for more info

## In both

*   checking whether package ‘envi’ can be installed ... WARNING
     ```
     Found the following significant warnings:
       Warning: no DISPLAY variable so Tk is not available
     See ‘/scratch/hb/revdepcheck/doFuture/checks/envi/new/envi.Rcheck/00install.out’ for details.
     ```

# progressify (0.2.0)

* GitHub: <https://github.com/futureverse/progressify>
* Email: <mailto:henrikb@braju.com>
* GitHub mirror: <https://github.com/cran/progressify>

Run `revdepcheck::revdep_details(, "progressify")` for more info

## In both

*   checking tests ...
     ```
     ...
       [22:12:56.520] |  :  .  local({
       [22:12:56.520] |  :  .      design <- Design
       [22:12:56.520] |  :  .      replications <- 5L
       [22:12:56.520] |  :  .      .progressr_steps <- if (length(replications) == 1L) 
       [22:12:56.520] |  :  .          replications * nrow(design)
       [22:12:56.520] |  :  .      else sum(replications)
       [22:12:56.520] |  :  .      .progressr_progressor <- progressr::progressor(steps = .progressr_steps)
       [22:12:56.520] |  :  .      .progressr_analyse <- Analyse
       [22:12:56.520] |  :  .      runSimulation(design = design, replications = replications, 
       [22:12:56.520] |  :  .          generate = Generate, analyse = function(condition, dat, 
       [22:12:56.520] |  :  .              fixed_objects = NULL, ...) {
       [22:12:56.520] |  :  .              on.exit(.progressr_progressor())
       [22:12:56.520] |  :  .              .progressr_analyse(condition = condition, dat = dat, 
       [22:12:56.520] |  :  .                  fixed_objects = fixed_objects, ...)
       [22:12:56.520] |  :  .          }, summarise = Summarise, verbose = FALSE, progress = FALSE)
       [22:12:56.520] |  :  .  })
       [22:12:56.522] |  :  Transpile call expression ... done
       [22:12:56.523] |  :  Evaluate transpiled call expression
       
       Simulation complete. Total execution time: 0.01s
       
       [22:12:57.788] |  transpile() ... done
       [22:12:57.788] progressify() ... done
       Error: length(output) == 0L is not TRUE
       Execution halted
     ```

# remiod (1.0.2)

* GitHub: <https://github.com/xsswang/remiod>
* Email: <mailto:xwang@imedacs.com>
* GitHub mirror: <https://github.com/cran/remiod>

Run `revdepcheck::revdep_details(, "remiod")` for more info

## In both

*   checking S3 generic/method consistency ... NOTE
     ```
     Mismatches for apparent methods not registered:
     rep:
       function(x, ...)
     rep.data.frame:
       function(x, times)
     See section ‘Registering S3 methods’ in the ‘Writing R Extensions’
     manual.
     ```

# sparrpowR (0.2.9)

* GitHub: <https://github.com/machiela-lab/sparrpowR>
* Email: <mailto:ian.buller@alumni.emory.edu>
* GitHub mirror: <https://github.com/cran/sparrpowR>

Run `revdepcheck::revdep_details(, "sparrpowR")` for more info

## In both

*   checking whether package ‘sparrpowR’ can be installed ... WARNING
     ```
     Found the following significant warnings:
       Warning: no DISPLAY variable so Tk is not available
     See ‘/scratch/hb/revdepcheck/doFuture/checks/sparrpowR/new/sparrpowR.Rcheck/00install.out’ for details.
     ```

# sRACIPE (2.4.0)

* GitHub: <https://github.com/lusystemsbio/sRACIPE>
* Email: <mailto:m.lu@northeastern.edu>

Run `revdepcheck::revdep_details(, "sRACIPE")` for more info

## In both

*   checking C++ specification ... NOTE
     ```
       Obsolete C++11 standard request will be ignored
     ```

*   checking DESCRIPTION meta-information ... NOTE
     ```
     License stub is invalid DCF.
     ```

*   checking R code for possible problems ... NOTE
     ```
     sracipeConvergeDist,RacipeSE: no visible global function definition for
       ‘polygon’
       (/scratch/hb/revdepcheck/doFuture/checks/sRACIPE/new/sRACIPE.Rcheck/00_pkg_src/sRACIPE/R/methods.R:1085-1087)
     Undefined global functions or variables:
       polygon
     Consider adding
       importFrom("graphics", "polygon")
     to your NAMESPACE file.
     ```

*   checking Rd files ... NOTE
     ```
     checkRd: (-1) sracipeHeatmapSimilarity.Rd:31: Lost braces
         31 | If clusterCut is missing, hierarchical clustering using /code{ward.D2}
            |                                                              ^
     checkRd: (-1) sracipeHeatmapSimilarity.Rd:32: Lost braces
         32 | and /code{distance  = (1-cor(x, method = "spear"))/2} will be used to 
            |          ^
     ```

# STARRS (1.0)

* Email: <mailto:daphne.giorgi@sorbonne-universite.fr>
* GitHub mirror: <https://github.com/cran/STARRS>

Run `revdepcheck::revdep_details(, "STARRS")` for more info

## In both

*   checking re-building of vignette outputs ... ERROR
     ```
     ...
     Error: processing vignette 'STARRS-clustering.Rmd' failed with diagnostics:
     Attempting to set up 72 localhost parallel workers with only 2 CPU cores available for this R process (per 'N/A'), which could result in a 3600% load. The hard limit is set to 300%. Overusing the CPUs has negative impact on the current R process, but also on all other processes of yours and others running on the same machine. See help("parallelly.maxWorkers.localhost", package = "parallelly") for further explanations and how to override the hard limit that triggered this error. By the way, was parallel::detectCores() used, because the number of workers (72) equals detectCores()? If so, please use parallelly::availableCores() instead
     --- failed re-building ‘STARRS-clustering.Rmd’
     
     --- re-building ‘STARRS-intro.Rmd’ using rmarkdown
     [WARNING] Deprecated: --mathjax. Use --math-method=mathjax[:URL] instead.
     --- finished re-building ‘STARRS-intro.Rmd’
     
     --- re-building ‘STARRS-median-mcm.Rmd’ using rmarkdown
     [WARNING] Deprecated: --mathjax. Use --math-method=mathjax[:URL] instead.
     --- finished re-building ‘STARRS-median-mcm.Rmd’
     
     --- re-building ‘STARRS-regression.Rmd’ using rmarkdown
     [WARNING] Deprecated: --mathjax. Use --math-method=mathjax[:URL] instead.
     --- finished re-building ‘STARRS-regression.Rmd’
     
     --- re-building ‘STARRS-robust-variance.Rmd’ using rmarkdown
     [WARNING] Deprecated: --mathjax. Use --math-method=mathjax[:URL] instead.
     --- finished re-building ‘STARRS-robust-variance.Rmd’
     
     SUMMARY: processing the following file failed:
       ‘STARRS-clustering.Rmd’
     
     Error: Vignette re-building failed.
     Execution halted
     ```

# survstan (0.0.7.1)

* GitHub: <https://github.com/fndemarqui/survstan>
* Email: <mailto:fndemarqui@est.ufmg.br>
* GitHub mirror: <https://github.com/cran/survstan>

Run `revdepcheck::revdep_details(, "survstan")` for more info

## In both

*   checking dependencies in R code ... NOTE
     ```
     Namespaces in Imports field not imported from:
       ‘RcppParallel’ ‘rstantools’
       All declared Imports should be used.
     ```

# vmeasur (0.1.4)

* Email: <mailto:jhuc964@aucklanduni.ac.nz>
* GitHub mirror: <https://github.com/cran/vmeasur>

Run `revdepcheck::revdep_details(, "vmeasur")` for more info

## In both

*   checking whether package ‘vmeasur’ can be installed ... WARNING
     ```
     Found the following significant warnings:
       Warning: no DISPLAY variable so Tk is not available
     See ‘/scratch/hb/revdepcheck/doFuture/checks/vmeasur/new/vmeasur.Rcheck/00install.out’ for details.
     ```

