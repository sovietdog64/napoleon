event_inherited();

huts = [];

radius = irandom_range(TILEW*5, TILEW*9);

for(var i=0; i<irandom_range(2, 5); i++) {
	var p = randPointInCircle(radius);
	var collision = collision_circle(p.x, p.y, HIGHEST_HOUSE_H, obj_hut, 0, 1)
	if(collision == noone) {
		var inst = instance_create_layer(x+p.x, y+p.y, layer, obj_hut, {creatorId : id});
		inst.sprite_index = choose(spr_hut);
		array_push(huts, inst);
	}
}