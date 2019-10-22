# Use phylotaR to source biological sequences for `suite_1`

# remotes::install_github('ropensci/remotes')
library(phylotaR)
# matk sequences for bromeliads at genus level
data("bromeliads")
#summary(bromeliads)
cid <- bromeliads@cids[[1]]
selected <- drop_clstrs(phylota = bromeliads, cid = cid)
selected <- drop_by_rank(phylota = selected, rnk = 'genus', n = 1)
txids <- get_txids(phylota = selected, sid = selected@sids, rnk = 'genus')
scnms <- get_tx_slot(phylota = selected, txid = txids, slt_nm = 'scnm')
scnms <- scnms[!duplicated(scnms)]
# random 10 genera (keep analysis fast)
scnms <- sample(x = scnms, size = 10)
# write to FASTA file with description as genus name
outfile <- file.path('1_suite', 'bromeliad_genera_matk.fasta')
write_sqs(phylota = selected, outfile = outfile, sid = names(scnms),
          sq_nm = scnms)
