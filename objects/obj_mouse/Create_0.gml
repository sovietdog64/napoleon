invHover = -1;
slotHover = -1;
invDrag = -1;
slotDrag = -1;
itemDrag = -1;

shouldDropItem = false;

depth = -999;

btnHover = -1;

mouseOver = function() {
	//reset hover results
	slotHover = -1;
	invHover = -1;
	btnHover = -1;
	shouldDropItem = false;
	
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
					if(point_in_rectangle(mx, my, p.x, p.y, p.x+INV_SLOT_SIZE, p.y+INV_SLOT_SIZE)) {
						other.slotHover = j;
						other.invHover = invArray;
						break;
					}
				}
				if(other.invHover != -1)
					other.shouldDropItem = false;
				else
					other.shouldDropItem = true;
			}
		}
	}
	
	if(instance_exists(obj_guiScreenPar))
		with(obj_guiScreenPar) {
			//Find the button the mouse is hovering over
			if(is_array(screen.buttons))
				for(var j=0; j<array_length(screen.buttons); j++) {
					var btn = screen.buttons[j];
					if(btn.rectangle.pointInRect(mx, my)) {
						other.btnHover = btn;
					}
				}
			if(!screen.rectangle.pointInRect(mx, my))
				other.shouldDropItem = true;
			else
				other.shouldDropItem = false;
		}
}
	
handleScreenInput = function() {
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
		else if(shouldDropItem) {
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