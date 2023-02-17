itemHover = -1;
invHover = -1;
slotHover = -1;
invDrag = -1;
slotDrag = -1;
itemDrag = -1;

btnHover = -1;

mouseOver = function() {
	//reset hover results
	slotHover = -1;
	invHover = -1;
	var mx = mouse_x-CAMX;
	var my = mouse_y-CAMY;
	
	for(var i=0; i<instance_number(obj_inventory); i++) {
		var inv = instance_find(obj_inventory, i);
		with(inv) {
			//Getting sllot/inv being hovered over
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
			
			//Find the button the mouse is hovering over
			if(is_array(buttons))
				for(var j=0; j<array_length(buttons); j++) {
					var btn = buttons[j];
					if(btn.rectangle.pointInRect(mx, my)) {
						other.btnHover = btn;
					}
				}
		}
	}
}
	
handleMouseInvInput = function() {
	mouseOver();
	//Handling mouse click in inv
	if(mouse_check_button_pressed(mb_left)) {
		//Placing items in slot that is being hovered
		if(invHover != -1) {
			var invItemHovered = duplicateItem(invHover[slotHover]);
			invHover[slotHover] = itemDrag;
			itemDrag = invItemHovered;
		}
		//Drop item when mouse clicked out of inventory
		else if(isItem(itemDrag)) {
			with(instance_create_layer(obj_player.x, obj_player.y, obj_player.layer, obj_item)) {
				item = duplicateItem(other.itemDrag);
			}
			itemDrag = -1;
		}
		
		//Click on button when hovering over button.
		if(btnHover != -1) {
			btnHover.clickAction();
		}
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