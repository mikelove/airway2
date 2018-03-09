library(here)
library(readr)
sra <- read_delim(here("inst","extdata","SraRunTable.txt"),delim="\t")

scrubPaths <- c("/path/to/your/annotation/","/path/to/your/fastq-files/")

scrub <- function(run, dir, scrubPaths) {
  files <- c("cmd_info.json","lib_format_counts.json")
  for (file in files) {
    path <- file.path(dir, file)
    suppressWarnings(lines <- readLines(path))
    for (sp in scrubPaths) {
      lines <- gsub(sp, "", lines)
    }
    writeLines(lines, path)
  }
}

for (run in sra$Run)
  scrub(run, here("inst","extdata","quants",run), scrubPaths)
