#! /usr/bin/env bash


## ---------------------------------------------------------------------
## Phase 1
## ---------------------------------------------------------------------

## Add packages to check
revdep/run.R --add-children

## Drop packages no longer on CRAN (2026-10-04)
# revdep/run.R --rm ...

## Requires sequential processing due to clashes, e.g. port and cache 
pkgs_seq=(polykde)
revdep/run.R --rm "${pkgs_seq[@]}"


## ---------------------------------------------------------------------
## Phase 2
## ---------------------------------------------------------------------
## Sequential
revdep/run.R --add "${pkgs_seq[@]}"
NSLOTS=1 revdep/run.R
