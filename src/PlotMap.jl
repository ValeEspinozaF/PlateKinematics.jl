using Plots, Shapefile

coastlines = Shapefile.shapes(Shapefile.Table(raw"C:\Users\nbt571\Documents\McS\Project_Folder\0_Data\ProcessedData\Shapes\Coastlines\Global_coastlines_2015_v1_low_res_0-0Ma_pyGplates_GK07.shp"));

plateBoundaries = Shapefile.shapes(Shapefile.Table(raw"C:\Users\nbt571\Documents\McS\Project_Folder\0_Data\ProcessedData\Shapes\Plate_Boundaries\PlateBoundaries_Matthews2016_0-0Ma_pyGplates_GK07_OpenLine.shp"));

plot(plateBoundaries, color=:black, lw=0.5)
plot!(coastlines, color=:lightgrey, lc=:lightgrey, lw=0.1)
plot!(size=(1100,600))