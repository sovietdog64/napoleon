#macro RESOLUTION_W 1366
#macro RESOLUTION_H 768
#macro INTERACTION_W sprite_get_width(spr_interactions)
#macro INTERACTION_H sprite_get_height(spr_interactions)

//These numbers are not in pixels. They are the amount of tiles that will be spawned on the x/y axis
#macro CHUNK_W 64
#macro CHUNK_H 64

#macro TILE_W 64
#macro TILE_H 64

#macro PX_CHUNK_W (CHUNK_W*TILE_W)
#macro PX_CHUNK_H (CHUNK_H*TILE_H)