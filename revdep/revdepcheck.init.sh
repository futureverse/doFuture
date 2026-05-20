#! /usr/bin/env bash

## Add packages to check
revdep/run.R --add-children

## Drop packages no longer on CRAN (2026-05-19)
revdep/run.R --rm oncomsm ldsr

