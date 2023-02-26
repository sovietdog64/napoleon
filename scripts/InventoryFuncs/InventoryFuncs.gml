//Returns the slot that contains the wanted item
//If found across multiple slots, then returns array of slots
function InvSearch(invArray, itemSpr_or_type, amount = 1) {
	var amountFound = 0;
	var slots = [];
	
	for(var i=0; i<array_length(invArray); i++) {
		var item = invArray[i];
		if(isItem(item) && item.itemSpr == itemSpr_or_type) {
			//If still didn't find the amount of the item needed, add on to the slots found
			if(amountFound < amount) {
				amountFound += item.amount;
				array_push(slots, i);
			}
			//If already found the amount, exit loop
			else
				break;
		}
		//if an item type was inputted, then search with that
		else if(script_exists(itemSpr_or_type)) {
			//if the item being checked is an instance of specified type
			if(is_instanceof(item, itemSpr_or_type)) {
				if(amountFound < amount) {
					amountFound += item.amount;
					array_push(slots, i);
				}
				else
					break;
			}
		}
		
	}


	//if found the right amount, 
	if(amountFound >= amount) {
		//and if more than 1 slot was found, return the array of slots
		if(array_length(slots) > 1)
			return slots;
		//if there was only one slot found, return that one.
		else if(array_length(slots) > 0)
			return slots[0];
	}
	//Return -1 if nothing found
	return -1;
}
	
function InvSearchContainsOnly(invArray, arrayOfItems) {
	var slots = [];
	//Finding all slots in inv that contain the right items. these slots will be in the "slots" array
	//This loop will immediately return false if it didn't find a required item
	for(var i=0; i<array_length(arrayOfItems); i++) {
		var reqItem = arrayOfItems[i];
		//if required item is not an item type, get its amount. if it is, then amount is 1.
		var amount = isItem(reqItem) ? reqItem.amount : 1;
		var sprOrItemType = isItem(reqItem) ? reqItem.itemSpr : reqItem;
		
		var search = InvSearch(invArray, sprOrItemType, amount);
		//if didn't find this required item, return false.
		if(search == -1)
			return false;
		else { //if did find, then add the slots found to the "slots" array
			if(is_array(search))
				slots = array_concat(slots, search);
			else
				array_push(slots, search);
		}
	}
	
	//This loop will then go through all slots that are not in the "slots" array and check if they are items.
	//If one of them is an item, it will immediately return false.
	//This way, it makes sure that the inventory strictly contains the same items as arrayOfItems
	for(var i=0; i<array_length(invArray); i++) {
		if(array_contains(slots, i)) // skip found slots
			continue;
			
		if(isItem(invArray[i])) //If current slot contains an item--it isn't a needed item--so return false.
			return false;
	}
	
	//Return true after all the checks.
	return true;
}

//Returns an item struct of the item you want to find.
//If found the amount of items across multiple slots, returns array of item structs.
function InvGet(invArray, itemSprite, amount = 1) {
	//Find the inv slot(s) containing the amount of the item needed
	var pos = InvSearch(invArray, itemSprite, amount);
	//If found the item(s)
	if(pos != -1) {
		//If only one slot was found, return the item in that slot.
		if(!is_array(pos))
			return invArray[pos];
		else {//More than one slot found? return an array of all items in all the slots.
			var items = [];
			for(var i=0; i<array_length(pos); i++)
				array_push(items, invArray[pos[i]]);
			return items;
		}
	}
	//couldn't find anything? return undefined.
	return undefined;
}

//Only use this if you want to find if the player has an item. I don't want to make this work, because it might get too impractical
function InvSearchPlayer( itemSprite, amount = 1) {
	//Gets the slot(s) containing wanted item
	var pos = InvSearch(global.invItems, itemSprite, amount);
	//If couldn't find slot(s), try looking through all hotbar slots.
	if(pos == -1)
		pos = InvSearch(global.hotbarItems, itemSprite, amount);
	//return the slot(s) found. will be -1 if no slot(s) were found
	return pos;
}

function InvGetPlayer(itemSprite, amount = 1) {
	
	var items = [];
	var temp = InvGet(global.invItems, itemSprite, amount);
	if(is_array(temp))
		items = temp;
	else if(temp != undefined)
		array_push(items, temp);
	else
		items = undefined;
	
	var items2 = [];
	var temp2 = InvGet(global.hotbarItems, itemSprite, amount);
	if(is_array(temp2))
		items2 = temp2;
	else if(temp2 != undefined)
		array_push(items2, temp2);
	else
		items2 = undefined;
	
	var fullArray = undefined;
	//if found items in both inventory & hotbar, the to-be-returned array will contain all item results.
	if(items != undefined && items2 != undefined)
		return array_concat(items,items2)
	//If items found in inventory only, return those items
	else if(items != undefined)
		return items;
	//If items found in hotbar only, return thsoe items.
	else if(items2 != undefined)
		return items2;
	//if nothing is found, then return undefined
	else
		return undefined;
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
	//Get item's constructor as a string
	var constructorName = instanceof(item)
	var scriptFunc = asset_get_index(constructorName);
	var newItem = new scriptFunc();
	
	//Update all values in the new item to be the same as the old item's
	var key, value;
	var keys = variable_struct_get_names(item);
    for (var i = array_length(keys)-1; i >= 0; --i) {
            key = keys[i];
            value = item[$ key];
            variable_struct_get(item, key);
            variable_struct_set(newItem, key, value);
    }
	//Return the item duplicate
	return newItem;
}

function removeEmptyItems(invArray) {
	for(var i=0; i<array_length(invArray); i++) {
		if(!isItem(invArray[i]))
			continue;
		if(invArray[i].amount <= 0)
			invArray[i] = -1;
	}
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
	instance_create_depth(0,0,0,obj_playerInvScreen);
}

function closeAllInvs() {instance_destroy(obj_inventory)};

function closeInv(inv) {instance_destroy(inv)};
