if (!requireNamespace("AzimuthAPI", quietly = TRUE)) {
  remotes::install_github("satijalab/AzimuthAPI")
}

library(AzimuthAPI)

DefaultAssay(kidney_obj) <- "Spatial.Polygons"

kidney_obj <- NormalizeData(kidney_obj)
kidney_obj <- CloudAzimuth(kidney_obj,
                           assay = "Spatial.Polygons",
                           model_version = "v1")

library(knitr)
knitr::kable(tail(kidney_obj@meta.data %>% select(4:last_col())))

kidney_obj_hc <- subset(kidney_obj, 
                        !is.na(final_level_confidence) & final_level_confidence > 0.7)

kidney_azimuth_QC_heatmaps <- make_azimuth_QC_heatmaps(kidney_obj_hc)

kidney_azimuth_QC_heatmaps[["Epithelial cell_1"]]

kidney_obj_hc <- RunUMAP(kidney_obj_hc,
                         dims = 1:128,
                         reduction = "azimuth_embed",
                         reduction.name = "azimuth_umap")

p2 <- DimPlot(kidney_obj_hc,
              group.by = "final_level_labels",
              label.size = 2.5,
              label = TRUE,
              reduction = "azimuth_umap",
              repel = TRUE) + NoLegend()

p2

