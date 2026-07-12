library(Seurat)
library(ggplot2)
library(patchwork)
library(dplyr)

path_to_data <- "C:/Users/wendy/visium_kidney_data"

# arrow 패키지 설치 (최초 1회만 실행)
install.packages("arrow")

# 공간 다각형(Polygon) 처리를 위한 sf 패키지 설치
install.packages("sf")

kidney_obj <- Load10X_Spatial(data.dir = path_to_data,
                              bin.size = c(8, "polygons"),
                              image.name = "tissue_hires_image.png")

Images(kidney_obj)
kidney_obj[["slice1.008um"]]
kidney_obj[["slice1.polygons"]]

tissue_image <- SpatialDimPlot(kidney_obj,
                               images = "slice1.008um",
                               alpha = 0,
                               image.scale = "hires") +
  ggtitle("Tissue image") + NoLegend()

# Define layer to customize axis text
theme_layer <- theme(axis.text.x = element_text(size = 10, angle = 45),
                     axis.text.y = element_text(size = 10),
                     axis.title.x = element_text(size = 10),
                     axis.title.y = element_text(size = 10))

tissue_image_with_axes <- tissue_image + 
  scale_x_continuous(n.breaks = 20) +
  scale_y_reverse(n.breaks = 20) +
  theme_layer

tissue_image_with_axes

zoom1_xlim <- c(2400, 3200)
zoom1_ylim <- c(3300, 3700)

kidney_obj[["zoom1.polygons"]] <- Crop(object = kidney_obj[["slice1.polygons"]],
                                       x = zoom1_xlim,
                                       y = zoom1_ylim,
                                       scale = "hires")

zoom2_xlim <- c(2750, 3150)
zoom2_ylim <- c(3350, 3650)

kidney_obj[["zoom2.polygons"]] <- Crop(object = kidney_obj[["slice1.polygons"]],
                                       x = zoom2_xlim,
                                       y = zoom2_ylim,
                                       scale = "hires")

kidney_obj[["zoom2.008um"]] <- Crop(object = kidney_obj[["slice1.008um"]],
                                    x = zoom2_xlim,
                                    y = zoom2_ylim,
                                    scale = "hires")

tissue_image_zoom1 <- SpatialDimPlot(kidney_obj,
                                     images = "zoom1.polygons",
                                     alpha = 0,
                                     image.scale = "hires") +
  ggtitle("Zoom level 1") + NoLegend()

tissue_image_zoom2 <- SpatialDimPlot(kidney_obj,
                                     images = "zoom2.polygons",
                                     alpha = 0,
                                     image.scale = "hires") +
  ggtitle("Zoom level 2") + NoLegend()

tissue_image_zoom1 + tissue_image_zoom2

sdp_8um_zoom <- SpatialDimPlot(kidney_obj,
                               images = "zoom2.008um",
                               pt.size.factor = 18,
                               stroke = 0.1,
                               alpha = 0.6,
                               image.scale = "hires",
                               cols = "turquoise4") +
  ggtitle("8µm bins") + NoLegend()

sdp_segm_zoom <- SpatialDimPlot(kidney_obj,
                                images = "zoom2.polygons",
                                plot_segmentations = TRUE,
                                stroke = 0.1,
                                alpha = 0.6,
                                image.scale = "hires",
                                cols = "turquoise4") + 
  ggtitle("Cell segmentations") + NoLegend()

sdp_8um_zoom + sdp_segm_zoom

