library(here)
library(readr)
sra <- read_delim(here("inst","extdata","SraRunTable.txt"),delim="\t")

run <- sra$Run

read1s <- here("inst","extdata","fastq",paste0(run,"_1.fastq.gz"))
read2s <- here("inst","extdata","fastq",paste0(run,"_2.fastq.gz"))
stopifnot(all(file.exists(c(read1s,read2s))))

salmonPath <- "Salmon-0.8.2_linux_x86_64/bin/salmon"
indexPath <- "gencode.v27_salmon_0.8.2"

salmon <- function(read1, read2, out, opts=c("-p 6", "--libType A", "--gcBias", "--biasSpeedSamp 5")) {
  system(paste(salmonPath, "quant", paste(opts, collapse=" "),
               "-i", indexPath, "-1", read1, "-2", read2, "-o", out))
}

# 4 minutes for first sample
for (i in 1:8)
  salmon(read1s[i], read2s[i], here("inst","extdata","quants",run[i]))
