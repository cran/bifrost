## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(bifrost)
# library(ape)
# library(phytools)
# library(mvMORPH)
# 
# set.seed(1)
# 
# # Simulate a tree
# tr <- pbtree(n = 50, scale = 1)
# 
# # Simulate multivariate traits under a single-regime BM1 model (no shifts)
# sigma <- diag(0.1, 2)  # 2 x 2 variance-covariance matrix for two traits
# theta <- c(0, 0)       # ancestral means for the two traits
# 
# sim <- mvSIM(
#   tree  = tr,
#   nsim  = 1,
#   model = "BM1",
#   param = list(
#     ntraits = 2,
#     sigma   = sigma,
#     theta   = theta
#   )
# )
# 
# # mvSIM returns either a matrix or a list of matrices depending on mvMORPH version
# X <- if (is.list(sim)) sim[[1]] else sim
# rownames(X) <- tr$tip.label
# 
# # Run bifrost's greedy search for shifts
# res <- searchOptimalConfiguration(
#   baseline_tree              = tr,
#   trait_data                 = X,
#   formula                    = "trait_data ~ 1",
#   min_descendant_tips        = 10,
#   num_cores                  = 1,
#   shift_acceptance_threshold = 20,  # conservative GIC threshold
#   IC                         = "GIC",
#   plot                       = FALSE,
#   store_model_fit_history    = FALSE,
#   verbose                    = FALSE
# )
# 
# # For this single-regime BM1 simulation, we typically expect no inferred shifts
# res$shift_nodes_no_uncertainty
# res$optimal_ic - res$baseline_ic
# str(res$VCVs)

## ----workflow_diagram, echo=FALSE, eval=TRUE, results='asis'------------------
svg_uri <- knitr::image_uri("quick-start/bifrost-workflow.svg")
cat(sprintf(
  '<p align="center"><img src="%s" alt="Workflow diagram showing setup, baseline scoring, greedy search, post-processing, and output steps in bifrost." style="max-width:100%%; height:auto;" /></p>',
  svg_uri
))

