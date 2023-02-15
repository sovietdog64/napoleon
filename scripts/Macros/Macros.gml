#macro RESOLUTION_W 1366
#macro RESOLUTION_H 768
#macro INTERACTION_W sprite_get_width(spr_interactions)
#macro INTERACTION_H sprite_get_height(spr_interactions)

//These numbers are not in pixels. They are the amount of tiles that will be spawned on the x/y axis
#macro CHUNK_W 64
#macro CHUNK_H 64

#macro CHUNK_AREA (CHUNK_W * CHUNK_H)

#macro TILEW 32
#macro TILEH 32

#macro PX_CHUNK_W (CHUNK_W*TILEW)
#macro PX_CHUNK_H (CHUNK_H*TILEH)

#macro CAMX camera_get_view_x(view_camera[0])
#macro CAMY camera_get_view_y(view_camera[0])

#macro CAMX2 (CAMX+RESOLUTION_W)
#macro CAMY2 (CAMY+RESOLUTION_H)

#macro SLOT_SIZE 64

#macro MAX_BUILDING_SIZE 260
