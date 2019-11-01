# # send output to Viewer rather than external X11 window
#options(rgl.useNULL = TRUE,
#        rgl.printRglwidget = TRUE)

library(rayshader)
library(rgl)


#Here, I load a map with the raster package.
# loadzip = tempfile() 
# download.file("https://tylermw.com/data/dem_01.tif.zip", loadzip)
# localtif = raster::raster(unzip(loadzip, "dem_01.tif"))
# unlink(loadzip)

#And convert it to a matrix:
localtif = raster::raster("/contents/sandbox/dem_01.tif")
elmat = matrix(raster::extract(localtif, raster::extent(localtif), buffer = 1000),
               nrow = ncol(localtif), ncol = nrow(localtif))

#localtif = raster::raster("sandbox/ikh-nart-dem-half-res.tif")
#elmat = matrix(raster::extract(localtif, raster::extent(localtif), buffer = 1000),
#               nrow = ncol(localtif), ncol = nrow(localtif))


# #We use another one of rayshader's built-in textures:
elmat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()
# 
# #sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 45, texture = "desert") %>%
  plot_map()

elmat %>%
  sphere_shade(sunangle = 45, texture = "desert") ->
  hillshade
# 
# #detect_water and add_water adds a water layer to the map:
 elmat %>%
   sphere_shade(texture = "desert") %>%
   add_water(detect_water(elmat), color = "desert") %>%
   plot_map()
# 
raymat = ray_shade(elmat)
# 
# #And we can add a raytraced layer from that sun direction as well:
 elmat %>%
   sphere_shade(texture = "desert") %>%
   add_water(detect_water(elmat), color = "desert") %>%
   add_shadow(raymat) %>%
   plot_map()
# 
# 
# #And here we add an ambient occlusion shadow layer, which models 
# #lighting from atmospheric scattering:
# 
 ambmat = ambient_shade(elmat)
# 
 elmat %>%
   sphere_shade(texture = "desert") %>%
   add_water(detect_water(elmat), color = "desert") %>%
   add_shadow(raymat) %>%
   add_shadow(ambmat) %>%
   plot_map()
# 
# 
# # Rayshader also supports 3D mapping by passing a texture map (either external or one produced by rayshader) into the plot_3d function.
# 
 elmat %>%
   sphere_shade(texture = "desert") %>%
   add_water(detect_water(elmat), color = "desert") %>%
   add_shadow(ray_shade(elmat, zscale = 3, maxsearch = 300), 0.5) %>%
   add_shadow(ambmat, 0.5) %>%
   plot_3d(elmat, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
 plot_map()
render_snapshot('/contents/sandbox/test123.png')
writeWebGL(dir = "/contents/sandbox/test")

#-------------- Create an elevation shaded png -----------------------------

#Create a palette
col_ramp <- colorRampPalette(c('khaki', "#54843f", "grey", "white"))

#Set up image output
png("sandbox/elevation_shading.png", width=ncol(localtif), height=nrow(localtif), units = "px", pointsize = 1)

par(mar = c(0,0,0,0), xaxs = "i", yaxs = "i") #Parameters to create a borderless image

raster::image(
  localtif,
  col = col_ramp(36),
  maxpixels = raster::ncell(localtif),
  axes = FALSE
)

dev.off()

#Load generated png image from disk
terrain_image <- png::readPNG("sandbox/elevation_shading.png")

#----------------- Draw Scene -----------------------------------------------

clear3d()

suppressWarnings(file.remove('sandbox/ikh-nart-new/index.html'))
terrain_image %>% 
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat, zscale = 3, maxsearch = 300), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0.5) %>%
  # plot_map()
  plot_3d(elmat, zscale = 5, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
# rgl.snapshot('sandbox/ikh-nart-new/snapshot-1.png')
# snapshot3d(filename = 'sandbox/ikh-nart-new/snapshot-2.png')

# rgl.postscript('sandbox/ikh-nart-new/snap.pdf', 'pdf')
writeWebGL(dir = "~/sandbox/ikh-nart-new")