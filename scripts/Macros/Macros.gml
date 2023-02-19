#macro RESOLUTION_W 683
#macro RESOLUTION_H 384
#macro INTERACTION_W sprite_get_width(spr_interactions)
#macro INTERACTION_H sprite_get_height(spr_interactions)

#macro LMOUSE_PRESSED mouse_check_button_pressed(mb_left)
#macro RMOUSE_PRESSED mouse_check_button_pressed(mb_right)

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

#macro INV_SLOT_SIZE 48
#macro INV_ITEM_SIZE 48	

#macro HIGHEST_HOUSE_W 192
#macro HIGHEST_HOUSE_H 300