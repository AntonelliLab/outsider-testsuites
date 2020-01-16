source("https://raw.githubusercontent.com/r-lib/remotes/master/install-github.R")$value("r-lib/remotes")
username <- 'ropensci'
repos <- c('outsider.base', 'outsider', 'outsider.devtools')
for (repo in repos) {
  cat('... Installing [', repo, ']\n')
  remotes::install_github(repo = paste0(username, '/', repo))
}
