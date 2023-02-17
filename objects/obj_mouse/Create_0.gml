itemHover = -1;
invHover = -1;
slotHover = -1;
invDrag = -1;
slotDrag = -1;
itemDrag = -1;

mouseOver = function() {
	//reset hover results
	slotHover = -1;
	invHover = -1;
	var mx = mouse_x-CAMX;
	var my = mouse_y-CAMY;
	
	for(var i=0; i<instance_number(obj_inventory); i++) {
		var inv = instance_find(obj_inventory, i);
		with(inv) {
			if(point_in_rectangle(
				mx,
				my,
				invRect[0].x, invRect[0].y,
				invRect[1].x, invRect[1].y
			))
			{
				for(var j=0; j<invSize; j++) {
					var p = slotPositions[j];
					if(point_in_rectangle(mx, my, p.x, p.y, p.x+SLOT_SIZE, p.y+SLOT_SIZE)) {
						other.slotHover = j;
						other.invHover = invArray;
					}
				}
			}
		}
	}
}
	
handleMouseInvInput = function() {
	mouseOver();
	if(invHover != -1 && mouse_check_button_pressed(mb_left)) {
		var invItemHovered = duplicateItem(invHover[slotHover]);
		invHover[slotHover] = itemDrag;
		itemDrag = invItemHovered;
	}
	else if(mouse_check_button_pressed(mb_left) && isItem(itemDrag)) {
		with(instance_create_layer(obj_player.x, obj_player.y, obj_player.layer, obj_item)) {
			item = duplicateItem(other.itemDrag);
		}
		itemDrag = -1;
	}
}
	
stateFree = function() {
	mouseOver();
	//drag an item if the slot is not empty
	if(mouse_check_button_pressed(mb_left) && slotHover != -1 && invHover[slotHover] != -1) {
		//enter item-dragging state
		state = stateDrag;
		var prevItemDragged = duplicateItem(itemDrag);
		itemDrag = duplicateItem(invHover[slotHover]);
		invHover[slotHover] = prevItemDragged;
	}
}

stateDrag = function() {
	mouseOver();
	if(mouse_check_button_pressed(mb_left)) {
		//if dragging item, place
		if(itemDrag != -1) 
			invHover[slotHover] = itemDrag;
		//Return to free state
		state = stateFree;
		itemDrag = -1;
		invDrag = -1;
		slotDrag = -1;
	}
}

state = stateFree;