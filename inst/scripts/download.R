accession2url <- function(x) {
  prefix <- "ftp://ftp.sra.ebi.ac.uk/vol1/fastq"
  dir1 <- paste0("/",substr(x,1,6))
  dir2 <- ifelse(nchar(x) == 9, "",
          ifelse(nchar(x) == 10, paste0("/00",substr(x,10,10)),
          ifelse(nchar(x) == 11, paste0("/0",substr(x,10,11)),
                 paste0("/",substr(x,10,12)))))
  c(paste0(prefix,dir1,dir2,"/",x,"/",x,"_1.fastq.gz"),
    paste0(prefix,dir1,dir2,"/",x,"/",x,"_2.fastq.gz"))
}

library(here)
library(readr)
sra <- read_delim(here("inst/extdata/SraRunTable.txt"),delim="\t")
ftp.files <- accession2url(sra$Run)
dir.create(here("inst/extdata/fastq"))

dl.dir <- "inst/extdata/fastq/"
for (i in seq_along(ftp.files)) {
  dl.to <- here(dl.dir,basename(ftp.files[i]))
  if (!file.exists(dl.to))
    system(paste("wget --no-clobber --random-wait --progress=dot:giga --directory-prefix", here(dl.dir), ftp.files[i]))
}
