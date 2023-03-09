alarm_set(2, room_speed*0.2);
var playerEntered = point_in_rectangle(obj_player.x,obj_player.y, x,y, x+rmWidth,y+rmHeight);

var list = ds_list_create();

collision_rectangle_list(x,y,x+rmWidth,y+rmWidth, obj_enemy, 0, 1, list, 0);
 
for(var i=0; i<ds_list_size(list); i++) {
	list[| i].playerInRoom = playerEntered;
}