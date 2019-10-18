# Phylogenetic pipeline ----
# This pipeline downloads sequence data, then creates a phylogenetic tree

# Libs ----
library(outsider)
verbosity_set(show_program = TRUE, show_docker = TRUE)

# Vars ----
wd <- file.path(tempdir(), 'suite_1_wd')
if (dir.exists(wd)) {
  unlink(x = wd, recursive = TRUE, force = TRUE)
}
dir.create(wd)

# Module installations ----
repos <- c('dombennett/om..mafft', 'dombennett/om..trimal',
           'dombennett/om..raxml')
service <- 'github'
for (repo in repos) {
  if (!is_module_installed(repo = repo)) {
    cat('Installing [', repo, ']....\n', sep = '')
    module_install(repo = repo, service = service)
  }
}

# Download ----
cat('Downloading test data ....\n')
seqs_file <- file.path(wd, 'ex_seqs.fasta')
if (!file.exists(seqs_file)) {
  download.file(url = 'https://mafft.cbrc.jp/alignment/software/ex1.txt',
                destfile = seqs_file)
}

# Alignment ----
cat('Aligning sequence data ....\n')
mafft <- module_import(fname = 'mafft', repo = 'dombennett/om..mafft')
al_file <- 'ex_al.fasta'
# mafft will run on host computer
mafft(arglist = c('--thread', '2', '--auto', seqs_file, '>', al_file),
      outdir = wd)

# Trimming ----
cat('Trim alignment ....\n')
trimal <- module_import(fname = 'trimal', repo = 'dombennett/om..trimal')
input_file <- file.path(wd, 'ex_al.fasta')
output_file <- 'trimmed_al.phy'
trimal(arglist = c('-in', input_file, '-out', output_file, '-automated1',
                   '-phylip'), outdir = wd)

# Phylogeny ----
cat('Infer phylogeny ....\n')
raxml <- module_import(fname = 'raxml', repo = 'dombennett/om..raxml')
input_file <- file.path(wd, output_file)
seed_n <- round(runif(n = 1, min = 1, max = 99999))
raxml(arglist = c('-m', 'GTRGAMMA', '-s', input_file, '-p', seed_n, '-n',
                  'fast_analysis', '-T', '2'),
      outdir = wd)

# Check results ----
cat('Check results ....\n')
cat('.... results dir contents:')
fls <- list.files(path = wd)
for (fl in fls) {
  cat('[', fl, ']\n')
}

# Module uninstallations ----
for (repo in repos) {
  if (is_module_installed(repo = repo)) {
    cat('Uninstalling [', repo, ']....\n', sep = '')
    module_uninstall(repo = repo)
  }
}
