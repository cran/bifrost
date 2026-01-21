## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, results='asis'-----------------------------------------------
cat("
<style>
/* Remove any default borders/shadows around vignette/pkgdown images */
img, .figure img, .figure > p > img {
  border: 0 !important;
  box-shadow: none !important;
  outline: none !important;
}
</style>
")

## ----jaw_gif_pkgdown, echo=FALSE, results='asis', eval=identical(Sys.getenv("IN_PKGDOWN"), "true")----
# cat('
# <p style="text-align:center">
#   <img src="./jaw-shape/Gogosardina_coatesi_jaw_customcrop.gif"
#        alt="Animated jaw model of *Gogosardina coatesi* showing landmark layout"
#        style="border:0; outline:0; box-shadow:none; max-width:80%; height:auto; display:inline-block;">
# </p>
# ')

## ----jaw_media_cran, echo=FALSE, fig.align="center", out.width="80%", fig.alt="Static frame of the jaw model; an animated GIF is shown on the package website.", eval = !identical(Sys.getenv("IN_PKGDOWN"), "true")----
knitr::include_graphics("jaw-shape/Gogosardina_coatesi_jaw_customcrop.png")

## ----jaw_caption, echo=FALSE, results='asis'----------------------------------
if (identical(Sys.getenv("IN_PKGDOWN"), "true")) {
  cat("> **Animated jaw model of *Gogosardina coatesi* (specimen NMV P228269).**  \n",
      "> The 3D model is publicly available on [MorphoSource](https://www.morphosource.org/concern/media/000670517?locale=en). The landmark scheme used in subsequent analyses includes six fixed points (red) and five curves (blue).\n")
} else {
  cat("> **Static frame shown here.** An animated version appears on the package website.  \n",
      "> 3D model of *Gogosardina coatesi* (specimen NMV P228269) is publicly available on ",
      "[MorphoSource](https://www.morphosource.org/concern/media/000670517?locale=en). The landmark scheme includes six fixed points (red) and five curves (blue).\n")
}

## ----troyer_fig1, echo=FALSE, fig.align="center", out.width="60%", fig.alt="Figure 1 from Troyer et al. (2025)."----
knitr::include_graphics("jaw-shape/gr1_lrg_png24.png")

## ----troyer_fig1_caption, echo=FALSE, results='asis'--------------------------
cat("> **Figure 1 from Troyer et al. 2025: Contrasting patterns of jaw-shape space exploration among early bony fishes.** Phylogenetic traitgram of the first principal component (PC1) of lower jaw shape in early osteichthyans (bony fishes). Learn more about Emily's research [here](https://emilymtroyer.weebly.com/).\n")

## ----load_packages, eval=FALSE------------------------------------------------
# library(bifrost)
# library(ape)
# library(phytools)
# # geomorph is needed for two.d.array
# # install.packages("geomorph")
# library(geomorph)

## ----load_data, eval=FALSE----------------------------------------------------
# # Define paths to the data files included in the package
# tree_path <- system.file("extdata", "jaw-shape", "mrbayes_prune_tree.RDS",
#                          package = "bifrost")
# landmark_path <- system.file("extdata", "jaw-shape", "jaws_coords.RDS",
#                              package = "bifrost")
# 
# # Load the phylogenetic tree and landmark data
# fish.tree <- readRDS(tree_path)
# landmarks <- readRDS(landmark_path)
# 
# # Ensure the tree is in the correct format (a phylo object, here we also
# # ladderize for downstream plotting)
# fish.tree <- ladderize(untangle(as.phylo(fish.tree)))
# 
# # The raw landmark data is a 3D array (landmarks x dimensions x species) after
# # GPA (Generalized Procrustes analysis)
# # We convert the 3D array into a 2D matrix for analysis using a function from
# # the geomorph package.
# fish.data <- two.d.array(landmarks)
# 
# # It's crucial to ensure the order of species in the trait data matrix matches
# # the order of tip labels in the phylogenetic tree.
# tip_order <- match(fish.tree$tip.label, rownames(fish.data))
# fish.data <- fish.data[tip_order, ]
# 
# # Let's inspect our data
# print(fish.tree)
# str(fish.data)

## ----run_bifrost_setup, eval=FALSE, message = TRUE----------------------------
# # ---- Optional: increase future globals limit (needed for large objects) ----
# options(future.globals.maxSize = 10 * 1024^3)
# 
# # ---- Optional: open a dedicated plotting device when running interactively ----
# # (You can skip this entirely if plot = FALSE)
# if (interactive()) {
#   if (.Platform$OS.type == "windows") {
#     windows()
#   } else if (Sys.info()[["sysname"]] == "Darwin") {
#     quartz()
#   } else {
#     x11()
#   }
# }
# 
# # ---- Optional: speed up SEQUENTIAL linear algebra via BLAS/OpenMP threads ----
# # NOTE: bifrost caps BLAS/OpenMP threads to 1 *inside* its PARALLEL blocks to
# # avoid oversubscription.
# {thread_vars <- c("OMP_NUM_THREADS","OPENBLAS_NUM_THREADS","MKL_NUM_THREADS",
#                   "VECLIB_MAXIMUM_THREADS")
# old_threads <- Sys.getenv(thread_vars, unset = NA_character_)
# 
# n_threads <- "4"  # must be a character string
# Sys.setenv(
#   OMP_NUM_THREADS        = n_threads,
#   OPENBLAS_NUM_THREADS   = n_threads,
#   MKL_NUM_THREADS        = n_threads,
#   VECLIB_MAXIMUM_THREADS = n_threads
# )
# }
# 
# # ---- Run the search ----
# set.seed(1)
# jaws_search <- searchOptimalConfiguration(
#   baseline_tree              = fish.tree,
#   trait_data                 = fish.data,
#   min_descendant_tips        = 10, #try 4 for higher resolution (but more CPU time)
#   num_cores                  = 4,
#   shift_acceptance_threshold = 20,
#   uncertaintyweights_par     = TRUE,
#   IC                         = "GIC",
#   plot                       = FALSE,
#   formula                    = "trait_data ~ 1",
#   method                     = "H&L",   # penalized likelihood for high-dimensional data
#   error                      = TRUE,
#   store_model_fit_history    = TRUE,
#   verbose                    = TRUE
# )
# 
# # Restore environment variables
# on.exit({
#   for (nm in names(old_threads)) {
#     val <- old_threads[[nm]]
#     if (is.na(val) || val == "") {
#       Sys.unsetenv(nm)
#     } else {
#       do.call(Sys.setenv, setNames(list(val), nm))
#     }
#   }
# }, add = TRUE)
# 

## ----print_method_demo, eval=FALSE--------------------------------------------
# # The bifrost_search object has a custom S3 print method:
# # typing the object shows a summary.
# jaws_search

## ----interpret_results, eval=FALSE--------------------------------------------
# 
# # View the output of the results object
# 
# # The node numbers where shifts were inferred and accepted
# print(jaws_search$shift_nodes_no_uncertainty)
# 
# # The final, optimal IC score compared to the baseline
# cat("Baseline GIC:", jaws_search$baseline_ic, "\n")
# cat("Optimal GIC:", jaws_search$optimal_ic, "\n")
# cat("Improvement (Delta GIC):", jaws_search$baseline_ic - jaws_search$optimal_ic, "\n")
# 
# #The model fit improvement is > 7000 GIC units
# 
# # The VCV matrices for each detected regime
# # This shows the estimated rates of evolution for each regime
# # The root state is always assigned to `0`
# heatmap(jaws_search$VCVs$`0`, labRow = "", labCol = "")
# 
# # We can also visualize/extract the estimated evolutionary correlations across
# # traits (for the 'root' regime)
# heatmap(cov2cor(jaws_search$VCVs$`0`), labRow = "", labCol = "")
# 
# # The ic_weights sub-object stores detailed information about shift support (
# # if uncertaintyweights_par = TRUE)
# print(as.matrix(jaws_search$ic_weights)) #print as matrix in chunk
# 
# # Extract the shift node numbers with corresponding IC weights
# print(cbind(node=jaws_search$ic_weights$node,
#             weight=jaws_search$ic_weights$ic_weight_withshift))
# 
# # Extract the nodes with weights > 95%
# print(with(jaws_search$ic_weights, {
#   sel <- ic_weight_withshift > 0.95
#   cbind(node = node[sel], weight = ic_weight_withshift[sel])
# }))
# 
# # These nodes have very strong statistical support for shift events
# 

## ----cor_heatmap_fig, echo=FALSE, fig.align="center", out.width="60%", fig.alt="Heatmap of estimated evolutionary correlations for the root regime in the jaw-shape example."----
knitr::include_graphics("jaw-shape/cor_heatmap.png")

## ----plot_decay, eval=FALSE---------------------------------------------------
# # Since we saved the model search history
# 
# # We can inspect the behavior of the search with this helper function
# plot_ic_acceptance_matrix(matrix_data =
#                             jaws_search$model_fit_history$ic_acceptance_matrix,
#                           rate_limits = c(-600,300), baseline_ic = NULL)
# 
# #to set the baseline to the 'true' global baseline, use the following:
# plot_ic_acceptance_matrix(matrix_data =
#                            jaws_search$model_fit_history$ic_acceptance_matrix,
#                          rate_limits = c(-800,600), baseline_ic = jaws_search$baseline_ic)
# 

## ----IC_decay_fig, echo=FALSE, fig.align="center", out.width="80%", fig.alt="Scatter plot showing information-criterion scores across sequentially evaluated sub-models. Accepted shifts are shown as blue points connected by a line, rejected shifts as red crosses, and the baseline IC as a black point. A grey line on a secondary axis shows the change in IC at each step, with labels marking the baseline and lowest accepted IC."----
knitr::include_graphics("jaw-shape/IC_decay.png")

## ----plot_tree, eval=FALSE----------------------------------------------------
# 
# # Mean branch-rate colors (viridis): dark purple = slow, yellow = fast
# cols  <- generateViridisColorScale(jaws_search$model_no_uncertainty$param)$NamedColors
# rates <- jaws_search$model_no_uncertainty$param[names(cols)]
# 
# plotSimmap(
#   jaws_search$tree_no_uncertainty_untransformed,
#   ftype = "off",
#   direction = "upwards",
#   colors = cols
# )
# 
# # ---- Continuous color bar (bottom-left, inside plot region) ----
# op <- par(xpd = NA); on.exit(par(op), add = TRUE)
# usr <- par("usr"); xr <- diff(usr[1:2]); yr <- diff(usr[3:4])
# 
# # Geometry (fractions of plot range)
# x0 <- usr[1] + 0.05 * xr
# x1 <- x0 + 0.70 * (0.30 * xr)
# y0 <- usr[3] + 0.06 * yr
# y1 <- y0 + 0.512 * (0.06 * yr)
# 
# vscale <- 0.64
# cols_ord <- cols[order(rates)]
# xs <- seq(x0, x1, length.out = length(cols_ord) + 1L)
# 
# rect(xs[-length(xs)], y0, xs[-1], y1, col = cols_ord, border = NA)
# rect(x0, y0, x1, y1, border = "grey30")
# 
# min_rate <- min(rates); max_rate <- max(rates)
# ratio_int <- if (is.finite(min_rate) && min_rate > 0)
#   as.integer(round(max_rate / min_rate)) else NA_integer_
# 
# text((x0 + x1) / 2, y1 + vscale * (0.03 * yr),
#      "Mean rate (slow \u2192 fast)", cex = 0.9)
# 
# #Vignette will be updated with additional plotting functions and post-hoc analyses
# 

## ----branch_rates_fig, echo=FALSE, fig.align="center", out.width="80%", fig.alt="Upward-oriented phylogenetic tree without tip labels. Branches are colored using a viridis gradient, where yellow branches represent faster inferred evolutionary rates and dark purple branches represent slower rates; different clades show distinct colors indicating variation in branch rates across the tree."----
knitr::include_graphics("jaw-shape/branch_rates.png")

