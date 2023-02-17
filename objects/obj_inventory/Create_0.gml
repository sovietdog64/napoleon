invSize = array_length(invArray);
slotPositions = [];
invRect = [];
for(var i=0; i<instance_number(obj_inventory); i++) {
	var inst = instance_find(obj_inventory, i);
	if(inst != instance_id) {
		//Prevent destroying hotbar inv
		if(invType == inventories.PLAYER_INV && inst.invType == inventories.PLAYER_INV)
			continue;
		instance_destroy(inst);
	}
}

var multiplier = SLOT_SIZE+5;
for(var i=0; i<invSize; i++) {
	var xx = x + (i mod rowLength) * multiplier + 2;
	var yy = y + (i div rowLength) * multiplier + 2;
	draw_sprite(spr_invSlot, 0, xx, yy);
	array_push(slotPositions, new Point(xx, yy));
}

var multiplier = SLOT_SIZE+5;
var x1 = x-10;
var y1 = y-10;
var x2 = x1 + 20+rowLength*multiplier;
var y2 = y1 + 20+(((invSize-1) div rowLength)+1)*multiplier;
invRect[0] = new Point(x1, y1);
invRect[1] = new Point(x2, y2);