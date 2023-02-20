invHover = -1;
slotHover = -1;
invDrag = -1;
slotDrag = -1;
itemDrag = -1;
selectedObj = -1;
/*set to true when an inventory can't have items placed in it*/
dontPutItem = false;

placeableColorBlend = c_green;

shouldDropItem = false;

depth = -9999;

btnHover = -1;

mouseOver = function() {
	//reset hover results
	slotHover = -1;
	invHover = -1;
	btnHover = -1;
	shouldDropItem = false;
	dontPutItem = false;
	
	var mx = GUI_MOUSE_X;
	var my = GUI_MOUSE_Y;
	
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
				other.dontPutItem = cannotPlaceItem;
				for(var j=0; j<invSize; j++) {
					var p = slotPositions[j];
					if(point_in_rectangle(mx, my, p.x,p.y, p.x+slotSize,p.y+slotSize)) {
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
	if(LMOUSE_PRESSED) {
		//Placing items in slot that is being hovered
		if(invHover != -1) {
			//If the item being dragged & the itme hovered are similar, place the stack into the slot.
			if(itemsAreSimilar(itemDrag, invHover[slotHover]) && !dontPutItem) {
				invHover[slotHover].amount += itemDrag.amount;
				itemDrag = -1;
			}
			//If not similar, swap the itme being dragged with the hovered item
			else {
				//If cannot put items in inventory
				if(dontPutItem) {
					if(keyboard_check(vk_shift) && instance_exists(obj_craftingScreen))
						with(obj_craftingScreen) {
							try{
								while(craftRecipie.canCraft(craftingSlots)) {
									giveItemToPlayer(craftRecipie.craftItem(craftingSlots));
								}
							}
							catch(err){}
						}
					//If no item dragged, then pick up item from inv
					else if(itemDrag == -1) {
						var invItemHovered = duplicateItem(invHover[slotHover]);
						invHover[slotHover] = itemDrag;
						itemDrag = invItemHovered;
						if(instance_exists(obj_craftingScreen)) {
							with(obj_craftingScreen) {
								craftRecipie.craftItem(craftingSlots);
							}
						}
					}
					//If item being dragged is similar to the item in the slot, pick up the item in the slot and update dragged item amount
					else if(itemsAreSimilar(itemDrag, invHover[slotHover])) {
						var temp = invHover[slotHover].amount;
						invHover[slotHover].amount = 0;
						itemDrag.amount += temp;
						if(invHover[slotHover].amount <= 0)
							invHover[slotHover] = -1;

						if(instance_exists(obj_craftingScreen)) {
							with(obj_craftingScreen) {
								craftRecipie.craftItem(craftingSlots);
							}
						}
					}
				}
				else {
					var invItemHovered = duplicateItem(invHover[slotHover]);
					invHover[slotHover] = itemDrag;
					itemDrag = invItemHovered;
				}
			}
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
	else if(RMOUSE_PRESSED && !dontPutItem) {
		if(invHover != -1) {
			var item = invHover[slotHover];
			if(itemDrag == -1 && isItem(item)) {
				var half = numRound(item.amount/2);
				itemDrag = duplicateItem(item);
				itemDrag.amount = half;
				item.amount = item.amount - half;
			}
			else if(itemsAreSimilar(itemDrag, item)){
				itemDrag.amount--;
				item.amount++;
				if(itemDrag.amount <= 0)
					itemDrag = -1;
			}
			else if(isItem(itemDrag)){
				invHover[slotHover] = duplicateItem(itemDrag);
				invHover[slotHover].amount = 1;
				itemDrag.amount--;
				if(itemDrag.amount <= 0)
					itemDrag = -1;
			}
		}
		//Drop item when mouse clicked out of inventory
		else if(shouldDropItem) {
			itemDrag.amount--;
			var newItem = duplicateItem(itemDrag);
			newItem.amount = 1;
			with(instance_create_layer(obj_player.x, obj_player.y, obj_player.layer, obj_item)) {
				id.item = newItem;
			}
			if(itemDrag.amount <= 0)
				itemDrag = -1;
		}
	}
}
	
stateFree = function() {
	mouseOver();
	//drag an item if the slot is not empty
	if(LMOUSE_PRESSED && slotHover != -1 && invHover[slotHover] != -1) {
		//enter item-dragging state
		state = stateDrag;
		var prevItemDragged = duplicateItem(itemDrag);
		itemDrag = duplicateItem(invHover[slotHover]);
		invHover[slotHover] = prevItemDragged;
	}
}

stateDrag = function() {
	mouseOver();
	if(LMOUSE_PRESSED) {
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