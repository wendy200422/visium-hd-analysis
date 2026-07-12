kidney_segm_pod <- subset(kidney_obj_hc, final_level_labels == "Podocyte")

Idents(kidney_segm_pod) <- "final_level_labels"

pod_annotations_tissue <- SpatialDimPlot(kidney_segm_pod,
                                         images = "slice1.polygons",
                                         plot_segmentations = TRUE,
                                         image.scale = "hires",
                                         cols = "cyan") + NoLegend()

pod_annotations <- SpatialDimPlot(kidney_segm_pod, 
                                  images = "slice1.polygons",
                                  image.alpha = 0,
                                  plot_segmentations = TRUE, 
                                  image.scale = "hires",
                                  cols = "turquoise4") + NoLegend()

pod_annotations_tissue + 
  pod_annotations + 
  plot_annotation(title = 'Cells w/ annotation \'Podocyte\'')

##
cell_types_of_interest <- c("Capillary EC",
                            "Pericyte",
                            "Podocyte",
                            "Renal epithelial cell - distal tubules",
                            "Renal epithelial cell - Loop of Henle",
                            "Type A intercalated cell",
                            "Type B intercalated cell")

kidney_segm_top <- subset(kidney_obj_hc,
                          final_level_labels %in% cell_types_of_interest)

Idents(kidney_segm_top) <- "final_level_labels"

cell_type_colors <- c("#06d31e", "#006326", "#000000", "#453494", "#ffaf01", "#00fffa", "#1da5f9")
names(cell_type_colors) <- cell_types_of_interest

full_image_annotated <- SpatialDimPlot(kidney_segm_top,
                                       images = "slice1.polygons",
                                       plot_segmentations = TRUE,
                                       alpha = 0.7,
                                       stroke = 0.04,
                                       image.scale = "hires",
                                       cols = cell_type_colors) +
  labs(fill = "Cell type")

full_image_annotated

# Define layers to customize the legend by putting it in three rows below the plot
legend_guide_layer <- list(theme(legend.position = "bottom",
                                 legend.text = element_text(size = 12),
                                 legend.title = element_blank()),
                           guides(fill = guide_legend(nrow = 3, byrow = TRUE)))

glom_zoom_annotated <- SpatialDimPlot(kidney_segm_top,
                                      images = "zoom1.polygons",
                                      group.by = "final_level_labels",
                                      plot_segmentations = TRUE,
                                      alpha = 0.7, 
                                      stroke = 0.1, 
                                      image.scale = "hires",
                                      cols = cell_type_colors) +
  legend_guide_layer

glom_zoom_annotated