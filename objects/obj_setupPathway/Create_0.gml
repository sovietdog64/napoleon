//Grid to pathfind on (Enemy collision mask must be less than size of grid cell. in this example, enemy is less than 16x16)
grid = mp_grid_create(0, 0, room_width/16, room_height/16, 16, 16);
//Add solids to collide with
mp_grid_add_instances(grid, obj_solid, 0);