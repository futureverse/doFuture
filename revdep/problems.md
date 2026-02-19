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
     See ‘/scratch/henrik/revdep/doFuture/checks/envi/new/envi.Rcheck/00install.out’ for details.
     ```

# GeDS (0.3.3)

* GitHub: <https://github.com/emilioluissaenzguillen/GeDS>
* Email: <mailto:Emilio.Saenz-Guillen@citystgeorges.ac.uk>
* GitHub mirror: <https://github.com/cran/GeDS>

Run `revdepcheck::revdep_details(, "GeDS")` for more info

## In both

*   checking whether package ‘GeDS’ can be installed ... WARNING
     ```
     Found the following significant warnings:
       Warning: no DISPLAY variable so Tk is not available
     See ‘/scratch/henrik/revdep/doFuture/checks/GeDS/new/GeDS.Rcheck/00install.out’ for details.
     ```

# ldsr (0.0.2)

* GitHub: <https://github.com/ntthung/ldsr>
* Email: <mailto:ntthung@gmail.com>
* GitHub mirror: <https://github.com/cran/ldsr>

Run `revdepcheck::revdep_details(, "ldsr")` for more info

## In both

*   checking C++ specification ... NOTE
     ```
       Specified C++11: please drop specification unless essential
     ```

# mikropml (1.7.0)

* GitHub: <https://github.com/SchlossLab/mikropml>
* Email: <mailto:sovacool@umich.edu>
* GitHub mirror: <https://github.com/cran/mikropml>

Run `revdepcheck::revdep_details(, "mikropml")` for more info

## In both

*   checking dependencies in R code ... NOTE
     ```
     Namespace in Imports field not imported from: ‘methods’
       All declared Imports should be used.
     ```

# oncomsm (0.1.4)

* GitHub: <https://github.com/Boehringer-Ingelheim/oncomsm>
* Email: <mailto:kevin.kunzmann@boehringer-ingelheim.com>
* GitHub mirror: <https://github.com/cran/oncomsm>

Run `revdepcheck::revdep_details(, "oncomsm")` for more info

## In both

*   checking re-building of vignette outputs ... ERROR
     ```
     ...
      4. ├─dplyr::filter(., to != "stable")
      5. ├─dplyr::summarize(...)
      6. ├─dplyr:::summarise.grouped_df(., dt = t - lag(t), from = lag(state), to = state, .groups = "drop")
      7. │ └─dplyr:::summarise_cols(.data, dplyr_quosures(...), by, "summarise")
      8. │   └─base::withCallingHandlers(...)
      9. └─dplyr:::dplyr_internal_error(...)
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
     Error: processing vignette 'oncomsm.Rmd' failed with diagnostics:
     ℹ In argument: `dt = t - lag(t)`.
     ℹ In group 1: `iter = 1`, `group_id = "A"`, `subject_id = "ID00827488"`.
     Caused by error:
     ! `dt` must be size 1, not 3.
     ℹ To return more or less than 1 row per group, use `reframe()`.
     --- failed re-building ‘oncomsm.Rmd’
     
     --- re-building ‘prior-choice.Rmd’ using rmarkdown
     [WARNING] Deprecated: --highlight-style. Use --syntax-highlighting instead.
     --- finished re-building ‘prior-choice.Rmd’
     
     SUMMARY: processing the following file failed:
       ‘oncomsm.Rmd’
     
     Error: Vignette re-building failed.
     Execution halted
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
     See ‘/scratch/henrik/revdep/doFuture/checks/sparrpowR/new/sparrpowR.Rcheck/00install.out’ for details.
     ```

# sRACIPE (2.2.0)

* GitHub: <https://github.com/lusystemsbio/sRACIPE>
* Email: <mailto:m.lu@northeastern.edu>

Run `revdepcheck::revdep_details(, "sRACIPE")` for more info

## In both

*   checking C++ specification ... NOTE
     ```
       Specified C++11: please drop specification unless essential
     ```

*   checking DESCRIPTION meta-information ... NOTE
     ```
     License stub is invalid DCF.
     ```

*   checking R code for possible problems ... NOTE
     ```
     sracipeSimulate: no visible binding for global variable
       ‘configurationTmp’
     sracipeSimulate: no visible binding for global variable ‘outFileGETmp’
     sracipeSimulate: no visible binding for global variable
       ‘outFileParamsTmp’
     sracipeSimulate: no visible binding for global variable ‘outFileICTmp’
     sracipeSimulate: no visible binding for global variable
       ‘outFileConvergeTmp’
     sracipeConvergeDist,RacipeSE: no visible global function definition for
       ‘polygon’
     Undefined global functions or variables:
       configurationTmp outFileConvergeTmp outFileGETmp outFileICTmp
       outFileParamsTmp polygon
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
     See ‘/scratch/henrik/revdep/doFuture/checks/vmeasur/new/vmeasur.Rcheck/00install.out’ for details.
     ```

# WeightedCluster (2.0)

* Email: <mailto:matthias.studer@unige.ch>
* GitHub mirror: <https://github.com/cran/WeightedCluster>

Run `revdepcheck::revdep_details(, "WeightedCluster")` for more info

## In both

*   checking re-building of vignette outputs ... WARNING
     ```
     ...
     
     --- re-building ‘WeightedClusterPreview.Rnw’ using knitr
     Warning in texi2dvi(file = file, pdf = TRUE, clean = clean, quiet = quiet,  :
       texi2dvi script/program not available, using emulation
     Error: processing vignette 'WeightedClusterPreview.Rnw' failed with diagnostics:
     unable to run pdflatex on 'WeightedClusterPreview.tex'
     LaTeX errors:
     ! LaTeX Error: File `textpos.sty' not found.
     
     Type X to quit or <RETURN> to proceed,
     or enter new name. (Default extension: sty)
     
     ! Emergency stop.
     <read *> 
              
     l.85 \usepackage
                     {tikz}^^M
     !  ==> Fatal error occurred, no output PDF file produced!
     --- failed re-building ‘WeightedClusterPreview.Rnw’
     
     SUMMARY: processing the following files failed:
       ‘WeightedClusterFR.Rnw’ ‘WeightedClusterPreview.Rnw’
     
     Error: Vignette re-building failed.
     Execution halted
     ```

