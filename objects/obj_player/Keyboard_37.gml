var list = ds_list_create();

collision_circle_list(x, y, TILEW*3, obj_enemy, 0, 1, list, 0);

for(var i=0; i<ds_list_size(list); i++) {
	damageEntity(list[| i], id, list[| i].hp, 5)
}

//giveItemToPlayer(new Gold(7));