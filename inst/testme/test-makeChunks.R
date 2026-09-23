library(doFuture)

makeChunks <- doFuture:::makeChunks

message("*** makeChunks() ...")

message("- nbrOfElements = 0")

for (nbrOfWorkers in 1:4) {
  chunks <- makeChunks(0L, nbrOfWorkers = nbrOfWorkers)
  stopifnot(identical(chunks, list()))

  chunks <- makeChunks(0L, nbrOfWorkers = nbrOfWorkers, future.chunk.size = 2L)
  stopifnot(identical(chunks, list()))

  for (future.scheduling in list(FALSE, TRUE, 0, 0.5, 1.0, 2.0)) {
    chunks <- makeChunks(0L, nbrOfWorkers = nbrOfWorkers, future.scheduling = future.scheduling)
    stopifnot(identical(chunks, list()))
  }
}

for (nbrOfElements in c(1L, 2L, 8L)) {
  for (nbrOfWorkers in seq_len(nbrOfElements + 1L)) {
    ## Defaults
    chunks <- makeChunks(nbrOfElements, nbrOfWorkers = nbrOfWorkers)
    str(chunks)
    idxs <- unlist(chunks, use.names = TRUE)
    str(idxs)
    stopifnot(length(idxs) == nbrOfElements)
    uidxs <- unique(idxs)
    stopifnot(length(uidxs) == nbrOfElements)
    nidxs <- vapply(idxs, FUN = length, FUN.VALUE = 0L)
    str(nidxs)
    stopifnot(all(nidxs >= 1))
    stopifnot(length(chunks) <= nbrOfWorkers)

    orderings <- list(
      NULL,
      "random",
      seq_len(nbrOfElements),
      function(n) rev(seq_len(n))
    )

    for (ordering in orderings) {
      ## future.chunk.size
      for (future.chunk.size in seq_len(nbrOfElements + 1L)) {
        if (!is.null(ordering)) attr(future.chunk.size, "ordering") <- ordering
        chunks <- makeChunks(nbrOfElements, nbrOfWorkers = nbrOfWorkers,
                             future.chunk.size = future.chunk.size)
        str(chunks)
        idxs <- unlist(chunks, use.names = TRUE)
        str(idxs)
        stopifnot(length(idxs) == nbrOfElements)
        uidxs <- unique(idxs)
        stopifnot(length(uidxs) == nbrOfElements)
        nidxs <- vapply(idxs, FUN = length, FUN.VALUE = 0L)
        str(nidxs)
        stopifnot(all(nidxs >= 1), all(nidxs <= future.chunk.size))
      }
    
      ## future.scheduling
      for (future.scheduling in list(FALSE, TRUE, 0, 0.01, 0.5, 1.0, 2.0, +Inf)) {
        if (!is.null(ordering)) attr(future.scheduling, "ordering") <- ordering
        chunks <- makeChunks(nbrOfElements, nbrOfWorkers = nbrOfWorkers,
                             future.scheduling = future.scheduling)
        str(chunks)
        idxs <- unlist(chunks, use.names = TRUE)
        str(idxs)
        stopifnot(length(idxs) == nbrOfElements)
        uidxs <- unique(idxs)
        stopifnot(length(uidxs) == nbrOfElements)
        nidxs <- vapply(idxs, FUN = length, FUN.VALUE = 0L)
        str(nidxs)
        stopifnot(all(nidxs >= 1))
      }
    } ## for (ordering ...)
  }
}


message("- Exceptions")

opt <- TRUE
attr(opt, "ordering") <- "unknown"
res <- tryCatch({
  makeChunks(3L, nbrOfWorkers = 2L, future.chunk.size = opt)
}, error = identity)
str(res)
stopifnot(inherits(res, "error"))

res <- tryCatch({
  makeChunks(3L, nbrOfWorkers = 2L, future.scheduling = opt)
}, error = identity)
str(res)
stopifnot(inherits(res, "error"))

message("- foreach() over an empty iterator launches zero futures")

registerDoFuture()
plan(sequential)

backend <- plan("backend")
for (op in c("%dofuture%", "%dopar%")) {
  n_before <- backend[["counters"]]["created"]

  res <- if (op == "%dofuture%") {
    foreach(i = integer(0)) %dofuture% { i }
  } else {
    foreach(i = integer(0)) %dopar% { i }
  }
  stopifnot(identical(res, list()))

  n_after <- backend[["counters"]]["created"]
  stopifnot(n_after - n_before == 0L)
}

message("*** makeChunks() ... DONE")

