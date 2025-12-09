# baskexact

<details>

* Version: 1.0.1
* GitHub: https://github.com/lbau7/baskexact
* Source code: https://github.com/cran/baskexact
* Date/Publication: 2024-04-09 13:30:02 UTC
* Number of recursive dependencies: 75

Run `revdepcheck::revdep_details(, "baskexact")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘ggplot2’
      All declared Imports should be used.
    ```

# envi

<details>

* Version: 1.0.1
* GitHub: https://github.com/lance-waller-lab/envi
* Source code: https://github.com/cran/envi
* Date/Publication: 2025-08-29 13:10:02 UTC
* Number of recursive dependencies: 151

Run `revdepcheck::revdep_details(, "envi")` for more info

</details>

## In both

*   checking whether package ‘envi’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/scratch/henrik/revdep/doFuture/checks/envi/new/envi.Rcheck/00install.out’ for details.
    ```

# GeDS

<details>

* Version: 0.3.3
* GitHub: https://github.com/emilioluissaenzguillen/GeDS
* Source code: https://github.com/cran/GeDS
* Date/Publication: 2025-06-30 07:10:06 UTC
* Number of recursive dependencies: 76

Run `revdepcheck::revdep_details(, "GeDS")` for more info

</details>

## In both

*   checking whether package ‘GeDS’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/scratch/henrik/revdep/doFuture/checks/GeDS/new/GeDS.Rcheck/00install.out’ for details.
    ```

# ISAnalytics

<details>

* Version: 1.20.0
* GitHub: https://github.com/calabrialab/ISAnalytics
* Source code: https://github.com/cran/ISAnalytics
* Date/Publication: 2025-10-29
* Number of recursive dependencies: 177

Run `revdepcheck::revdep_details(, "ISAnalytics")` for more info

</details>

## In both

*   checking Rd files ... NOTE
    ```
    checkRd: (-1) refGenes_hg19.Rd:21: Lost braces; missing escapes or markup?
        21 | \item Download from {http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/}
           |                     ^
    ```

# ldsr

<details>

* Version: 0.0.2
* GitHub: https://github.com/ntthung/ldsr
* Source code: https://github.com/cran/ldsr
* Date/Publication: 2020-05-04 14:40:09 UTC
* Number of recursive dependencies: 67

Run `revdepcheck::revdep_details(, "ldsr")` for more info

</details>

## In both

*   checking C++ specification ... NOTE
    ```
      Specified C++11: please drop specification unless essential
    ```

# mikropml

<details>

* Version: 1.7.0
* GitHub: https://github.com/SchlossLab/mikropml
* Source code: https://github.com/cran/mikropml
* Date/Publication: 2025-10-29 03:30:02 UTC
* Number of recursive dependencies: 180

Run `revdepcheck::revdep_details(, "mikropml")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘methods’
      All declared Imports should be used.
    ```

# modeltime

<details>

* Version: 1.3.2
* GitHub: https://github.com/business-science/modeltime
* Source code: https://github.com/cran/modeltime
* Date/Publication: 2025-08-28 23:40:09 UTC
* Number of recursive dependencies: 237

Run `revdepcheck::revdep_details(, "modeltime")` for more info

</details>

## In both

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 50 lines of output:
        'test-algo-seasonal_decomp_ets.R:10:5',
        'test-algo-seasonal_reg_tbats.R:20:5', 'test-algo-seasonal_reg_tbats.R:35:5',
        'test-algo-seasonal_reg_tbats.R:93:5', 'test-algo-temporal_hierarchy.R:8:5',
        'test-algo-window_reg.R:24:5', 'test-algo-window_reg.R:69:5',
        'test-algo-window_reg.R:100:5', 'test-algo-window_reg.R:153:5',
        'test-algo-window_reg.R:206:5', 'test-algo-window_reg.R:241:5',
    ...
       5. │   └─parsnip:::xy_xy(...)
       6. │     └─parsnip:::eval_mod(...)
       7. │       └─rlang::eval_tidy(e, env = envir, ...)
       8. └─modeltime::prophet_xgboost_fit_impl(...)
       9.   └─modeltime::xgboost_predict(fit_xgboost, newdata = xreg_tbl)
      
      [ FAIL 1 | WARN 0 | SKIP 80 | PASS 0 ]
      Error:
      ! Test failures.
      Execution halted
    ```

*   checking re-building of vignette outputs ... ERROR
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘getting-started-with-modeltime.Rmd’ using rmarkdown
    
    Quitting from getting-started-with-modeltime.Rmd:162-171 [unnamed-chunk-9]
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    <error/rlang_error>
    Error in `switch()`:
    ! EXPR must be a length 1 vector
    ---
    Backtrace:
    ...
    
    Error: processing vignette 'getting-started-with-modeltime.Rmd' failed with diagnostics:
    EXPR must be a length 1 vector
    --- failed re-building ‘getting-started-with-modeltime.Rmd’
    
    SUMMARY: processing the following file failed:
      ‘getting-started-with-modeltime.Rmd’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# pareg

<details>

* Version: 1.8.0
* GitHub: https://github.com/cbg-ethz/pareg
* Source code: https://github.com/cran/pareg
* Date/Publication: 2024-04-30
* Number of recursive dependencies: 323

Run `revdepcheck::revdep_details(, "pareg")` for more info

</details>

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘pareg-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: as.data.frame.pareg
    > ### Title: as.data.frame for an object of class 'pareg'.
    > ### Aliases: as.data.frame.pareg
    > 
    > ### ** Examples
    > 
    > df_genes <- data.frame(
    ...
        Found existing installation: pip 25.0.1
        Uninstalling pip-25.0.1:
          Successfully uninstalled pip-25.0.1
    Successfully installed pip-25.3 setuptools-80.9.0 wheel-0.45.1
    Installing packages: 'tensorflow==2.10.0', 'tensorflow-probability==0.14.0'
    + /c4/home/henrik/.cache/R/basilisk/1.22.0/pareg/1.8.0/pareg/bin/python -m pip install --upgrade --no-user 'tensorflow==2.10.0' 'tensorflow-probability==0.14.0'
    ERROR: Could not find a version that satisfies the requirement tensorflow==2.10.0 (from versions: 2.16.0rc0, 2.16.1, 2.16.2, 2.17.0rc0, 2.17.0rc1, 2.17.0, 2.17.1, 2.18.0rc0, 2.18.0rc1, 2.18.0rc2, 2.18.0, 2.18.1, 2.19.0rc0, 2.19.0, 2.19.1, 2.20.0rc0, 2.20.0)
    ERROR: No matching distribution found for tensorflow==2.10.0
    Error: Error installing package(s): "'tensorflow==2.10.0'", "'tensorflow-probability==0.14.0'"
    Execution halted
    ```

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Complete output:
      > library(testthat)
      > library(pareg)
      Loading required package: tensorflow
      Loading required package: tfprobability
      
      
    ...
          Found existing installation: pip 25.0.1
          Uninstalling pip-25.0.1:
            Successfully uninstalled pip-25.0.1
      Successfully installed pip-25.3 setuptools-80.9.0 wheel-0.45.1
      Installing packages: 'tensorflow==2.10.0', 'tensorflow-probability==0.14.0'
      + /c4/home/henrik/.cache/R/basilisk/1.22.0/pareg/1.8.0/pareg/bin/python -m pip install --upgrade --no-user 'tensorflow==2.10.0' 'tensorflow-probability==0.14.0'
      ERROR: Could not find a version that satisfies the requirement tensorflow==2.10.0 (from versions: 2.16.0rc0, 2.16.1, 2.16.2, 2.17.0rc0, 2.17.0rc1, 2.17.0, 2.17.1, 2.18.0rc0, 2.18.0rc1, 2.18.0rc2, 2.18.0, 2.18.1, 2.19.0rc0, 2.19.0, 2.19.1, 2.20.0rc0, 2.20.0)
      ERROR: No matching distribution found for tensorflow==2.10.0
      Error: Error installing package(s): "'tensorflow==2.10.0'", "'tensorflow-probability==0.14.0'"
      Execution halted
    ```

*   checking re-building of vignette outputs ... ERROR
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘pareg.Rmd’ using rmarkdown
    The magick package is required to crop "/scratch/henrik/revdep/doFuture/checks/pareg/new/pareg.Rcheck/vign_test/pareg/vignettes/pareg_files/figure-html/unnamed-chunk-4-1.png" but not available.
    The magick package is required to crop "/scratch/henrik/revdep/doFuture/checks/pareg/new/pareg.Rcheck/vign_test/pareg/vignettes/pareg_files/figure-html/unnamed-chunk-5-1.png" but not available.
    Requirement already satisfied: pip in /c4/home/henrik/.cache/R/basilisk/1.22.0/pareg/1.8.0/pareg/lib/python3.12/site-packages (25.0.1)
    Collecting pip
      Using cached pip-25.3-py3-none-any.whl.metadata (4.7 kB)
    Collecting wheel
      Using cached wheel-0.45.1-py3-none-any.whl.metadata (2.3 kB)
    Collecting setuptools
    ...
    --- re-building ‘pathway_similarities.Rmd’ using rmarkdown
    The magick package is required to crop "/scratch/henrik/revdep/doFuture/checks/pareg/new/pareg.Rcheck/vign_test/pareg/vignettes/pathway_similarities_files/figure-html/unnamed-chunk-2-1.png" but not available.
    The magick package is required to crop "/scratch/henrik/revdep/doFuture/checks/pareg/new/pareg.Rcheck/vign_test/pareg/vignettes/pathway_similarities_files/figure-html/unnamed-chunk-3-1.png" but not available.
    --- finished re-building ‘pathway_similarities.Rmd’
    
    SUMMARY: processing the following file failed:
      ‘pareg.Rmd’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

*   checking for portable file names ... NOTE
    ```
    Found the following non-portable file paths:
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_ablation_study/config.yaml
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_ablation_study/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_dispersion_fitting/config.yaml
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_dispersion_fitting/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_real_datasets/config.yaml
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_real_datasets/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_regularization_effect/config.yaml
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_regularization_effect/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_regularization_parameter/config.yaml
    ...
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_response_distribution/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_similarity_measures/config.yaml
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_similarity_measures/params.csv
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/workflow/scripts/compare_rocauc_vs_loss.R
      pareg/inst/scripts/synthetic_benchmark/resources/multi_config_workflow/config_regularization_parameter
    
    Tarballs are only required to store paths of up to 100 bytes and cannot
    store those of more than 256 bytes, with restrictions including to 100
    bytes for the final component.
    See section ‘Package structure’ in the ‘Writing R Extensions’ manual.
    ```

*   checking whether package ‘pareg’ can be installed ... NOTE
    ```
    Found the following notes/warnings:
      Non-staged installation was used
    See ‘/scratch/henrik/revdep/doFuture/checks/pareg/new/pareg.Rcheck/00install.out’ for details.
    ```

# sparrpowR

<details>

* Version: 0.2.9
* GitHub: https://github.com/machiela-lab/sparrpowR
* Source code: https://github.com/cran/sparrpowR
* Date/Publication: 2025-08-29 13:20:02 UTC
* Number of recursive dependencies: 128

Run `revdepcheck::revdep_details(, "sparrpowR")` for more info

</details>

## In both

*   checking whether package ‘sparrpowR’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/scratch/henrik/revdep/doFuture/checks/sparrpowR/new/sparrpowR.Rcheck/00install.out’ for details.
    ```

# sRACIPE

<details>

* Version: 2.2.0
* GitHub: https://github.com/lusystemsbio/sRACIPE
* Source code: https://github.com/cran/sRACIPE
* Date/Publication: 2025-10-29
* Number of recursive dependencies: 96

Run `revdepcheck::revdep_details(, "sRACIPE")` for more info

</details>

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

# survstan

<details>

* Version: 0.0.7.1
* GitHub: https://github.com/fndemarqui/survstan
* Source code: https://github.com/cran/survstan
* Date/Publication: 2024-04-12 16:50:02 UTC
* Number of recursive dependencies: 111

Run `revdepcheck::revdep_details(, "survstan")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘RcppParallel’ ‘rstantools’
      All declared Imports should be used.
    ```

# tglkmeans

<details>

* Version: 0.5.5
* GitHub: https://github.com/tanaylab/tglkmeans
* Source code: https://github.com/cran/tglkmeans
* Date/Publication: 2024-05-15 08:40:02 UTC
* Number of recursive dependencies: 85

Run `revdepcheck::revdep_details(, "tglkmeans")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘doRNG’
      All declared Imports should be used.
    ```

# vmeasur

<details>

* Version: 0.1.4
* GitHub: NA
* Source code: https://github.com/cran/vmeasur
* Date/Publication: 2021-11-11 19:00:02 UTC
* Number of recursive dependencies: 122

Run `revdepcheck::revdep_details(, "vmeasur")` for more info

</details>

## In both

*   checking whether package ‘vmeasur’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/scratch/henrik/revdep/doFuture/checks/vmeasur/new/vmeasur.Rcheck/00install.out’ for details.
    ```

# WeightedCluster

<details>

* Version: 1.8-1
* GitHub: NA
* Source code: https://github.com/cran/WeightedCluster
* Date/Publication: 2024-12-10 22:00:02 UTC
* Number of recursive dependencies: 72

Run `revdepcheck::revdep_details(, "WeightedCluster")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘BigDataSA.Rmd’ using rmarkdown
    [WARNING] Deprecated: --highlight-style. Use --syntax-highlighting instead.
    --- finished re-building ‘BigDataSA.Rmd’
    
    --- re-building ‘ClusterExternalValidSA.Rmd’ using rmarkdown
    [WARNING] Deprecated: --highlight-style. Use --syntax-highlighting instead.
    --- finished re-building ‘ClusterExternalValidSA.Rmd’
    
    --- re-building ‘ClusterValidSA.Rmd’ using rmarkdown
    ...
    l.85 \usepackage
                    {tikz}^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘WeightedClusterPreview.Rnw’
    
    SUMMARY: processing the following files failed:
      ‘WeightedClusterFR.Rnw’ ‘WeightedClusterPreview.Rnw’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

