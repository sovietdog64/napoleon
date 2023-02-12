return;
var dep = layer_get_depth(layer_get_id("Ground"))
layer_destroy(layer_get_id("Ground"))
var lay = layer_create(dep, "Ground")
var size = power(2, 8)+1;
terrainMap = ds_grid_create(size, size)
lazyFloodFill(terrainMap, 0, 0, 0.99999)
diamondSquare2(terrainMap, 10, 0)
ds_grid_clear(allChunks, 0)

placeSprites();