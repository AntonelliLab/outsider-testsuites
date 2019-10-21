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
cat('.... install modules ....\n')
repos <- c('dombennett/om..mafft', 'dombennett/om..trimal',
           'dombennett/om..raxml')
service <- 'github'
for (repo in repos) {
  if (!is_module_installed(repo = repo)) {
    cat('.... .... [', repo, '] ....\n', sep = '')
    module_install(repo = repo, service = service, force = TRUE,
                   update = 'always', tag = 'latest', verbose = TRUE)
  }
}

# Alignment ----
cat('.... align sequence data ....\n')
mafft <- module_import(fname = 'mafft', repo = 'dombennett/om..mafft')
seqs_file <- file.path('1_suite', 'bromeliad_genera_matk.fasta')
al_file <- file.path(wd, 'matk_al.fasta')
mafft(arglist = c('--thread', '2', '--auto', seqs_file, '>', al_file))

# Trimming ----
cat('.... trim alignment ....\n')
trimal <- module_import(fname = 'trimal', repo = 'dombennett/om..trimal')
output_file <- 'trimmed_al.phy'
trimal(arglist = c('-in', al_file, '-out', output_file, '-automated1',
                   '-phylip'), outdir = wd)

# Phylogeny ----
cat('.... infer phylogeny ....\n')
raxml <- module_import(fname = 'raxml', repo = 'dombennett/om..raxml')
input_file <- file.path(wd, output_file)
seed_n <- round(runif(n = 1, min = 1, max = 99999))
raxml(arglist = c('-m', 'GTRGAMMA', '-s', input_file, '-p', seed_n, '-n',
                  'fast_analysis', '-T', '2'),
      outdir = wd)

# Check results ----
cat('.... check results ....\n')
cat('.... .... results dir contents:\n')
fls <- list.files(path = wd)
for (fl in fls) {
  cat('[', fl, ']\n', sep = '')
}
cat('.... .... best tree Newick (no branch lengths):\n')
tree_txt <- readLines(con = file.path(wd, fls[grepl(pattern = 'bestTree',
                                                    x = fls)]))[[1]]
tree_txt <- gsub(pattern = ':[0-9\\.]+', replacement = '', x = tree_txt)
cat(tree_txt, '\n')

# Module uninstallations ----
cat('.... uninstall modules ....\n')
for (repo in repos) {
  if (is_module_installed(repo = repo)) {
    cat('.... .... [', repo, ']....\n', sep = '')
    module_uninstall(repo = repo)
  }
}
