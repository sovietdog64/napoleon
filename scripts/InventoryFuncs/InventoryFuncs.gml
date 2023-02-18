function InvSearch(invArray, itemSprite) {
	for(var i=0; i<array_length(invArray); i++)
		if(isItem(invArray[i]) && invArray[i].itemSpr == itemSprite)
			return i;
			
	return -1;
}

function InvRemove(invArray, itemSprite, amount = undefined) {
	var item = InvSearch(invArray, itemSprite);
	if(isItem(item)) {
		if(amount != undefined) {
			item.amount -= amount;
			return true;
		}
		else {
			item.amount = 0;
			return true;
		}
	}
	return false;
}

function InvAdd(invArray, item) {
	if(!isItem(item))
		return false;
	for(var i=0; i<array_length(invArray); i++) {
		var invItem = invArray[i];
		if(isItem(invItem) && invItem.itemSpr == item.itemSpr) {
			invItem.amount += item.amount;
			return true;
		}
		else if(invItem == -1) {
			invArray[i] = item;
			return true;
		}
	}
	return false;
}
	
function duplicateItem(item) {
	if(!isItem(item))
		return item;
	return copyStruct(item);
}
	
//invs are the inv arrays
//a slot is an index in the array
function InvSwap(invFrom, slotFrom, invTo, slotTo) {
	var itemFrom = duplicateItem(invFrom[slotFrom]);
	invFrom[slotFrom] = duplicateItem(invTo[slotTo]);
	invTo[slotTo] = itemFrom;
}
	
function pointInSprite(px, py, sprite, sprX, sprY) {
	var w = sprite_get_width(sprite);
	var h = sprite_get_height(sprite);
	var xOff = sprite_get_xoffset(sprite);
	var yOff = sprite_get_yoffset(sprite);
	//Make function check from top left of sprite
	sprX -= xOff;
	sprY -= yOff;
	return point_in_rectangle(px, py, sprX, sprY, sprX+w, sprY+w)
}

function openPlayerInv() {
	var w = sprite_get_width(spr_btnCrafting);
	var h = sprite_get_height(spr_btnCrafting);
	var xx = RESOLUTION_W-w*1.5;
	var yy = RESOLUTION_H*0.8;
	var btnAction = function() {
		closeAllInvs();
		instance_create_depth(0, 0, 100, obj_craftingScreen);
	}
	var btns = [new GuiButton(spr_btnCrafting, 0, xx, yy, btnAction)]
	instance_create_layer(RESOLUTION_W*0.1,RESOLUTION_H*0.1,
							layer,
							obj_inventory,
							{
								invArray : global.invItems,
								invType : inventories.PLAYER_INV,
								buttons : btns,
							});
						
	instance_create_layer(RESOLUTION_W*0.1,RESOLUTION_H*0.8,
							layer,
							obj_inventory,
							{
								invArray : global.hotbarItems,
								invType : inventories.PLAYER_INV,
								rowLength : array_length(global.hotbarItems),
							});
}

function closeAllInvs() {instance_destroy(obj_inventory)};

function closeInv(inv) {instance_destroy(inv)};