if(global.screenOpen || global.gamePaused)
	return;

if(hp <= 0) {
	with(instance_create_layer(x, y, "Instances", obj_item))
		item = other.item;
	instance_destroy()
}

prevHp = hp;