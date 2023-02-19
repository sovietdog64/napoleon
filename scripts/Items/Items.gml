function Item(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum = itemAnimations.NONE) constructor {
	itemSpr = itemSprite;
	amount = itemAmount;
	damage = dmg;
	name = itemName;
	desc = itemDescription;
	animationType = animationTypeEnum;
}

function Placeable(sprite, rightClickFunction = undefined, leftClickFunction = undefined) {
	placedSprite = sprite;
	rightClickAction = rightClickFunction;
	leftClickAction = leftClickFunction;
}

function PlaceableItem(itemSprite, itemAmount, dmg, itemName, itemDescription, sprite, rightClickFunction = function(){}, leftClickFunction = function(){}) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription) constructor {
	solid = true;
}

//Returns the amount needed to remove after removing
//Ex. item has amount of 3. amount to remove was 10. The item's amount will be subtracted to 0, and the func will return 7, because 3 out of 10 items were removed.
function removeFromItem(item, amountToRemove) {
	if(!isItem(item))
		return -1;
	var diff = item.amount - amountToRemove;
	if(diff < 0) {
		var temp = item.amount;
		item.amount = 0;
		amountToRemove -= temp;
	}
	else if(diff > 0) {
		item.amount -= amountToRemove;
		amountToRemove = 0;
	}
	else if(diff == 0) {
		item.amount -= amountToRemove;
		amountToRemove = 0;
	}
	
	return amountToRemove;
}

#region all item constructors

///@param {array} outputArray An optional param. Use it if you want to run script_execute() on it.
function Workbench(_amount = 1, outputArray = undefined) : PlaceableItem(spr_woodBench,_amount,0,"Workbench") constructor {
	//Output a new workbench into the output array's first index
	if(is_array(outputArray)) {
		outputArray[0] = new Workbench();
		return;
	}
	desc = "A bench used for making a variety of things\nCrafting slots: " + string(4);
	
	placedSprite = spr_woodBenchP;
	static rightClickAction = function() {
		instance_create_depth(0,0,0,obj_craftingScreen, {numOfSlots : 4})
	};
	
	static leftClickAction = function(){}
	
	solid = true;
}
	
function WoodHatchet(_amount = 1, outputArray = undefined) : Item(spr_woodHatchet,_amount,2,"Wood Hatchet", "Hatchet that can cut down trees\nDamage: 2", itemAnimations.KNIFE_STAB) constructor {
	if(is_array(outputArray)) {
		outputArray[0] = new WoodHatchet();
		return;
	}
}
	
function Wood(_amount = 1, outputArray = undefined) : Item(spr_wood,_amount,0,"Wood",":Resource:") constructor {
	if(is_array(outputArray)) {
		outputArray[0] = new Wood();
		return;
	}
}	

#endregion

function placeItem(placeableItem, placeX, placeY) {
	if(!is_struct(placeableItem))
		return 0;
	if(!variable_struct_exists(placeableItem, "placedSprite"))
		return 0;
	var newItem = duplicateItem(placeableItem);
	newItem.amount = 1;
	placeableItem.amount--;
	instance_create_layer(
		placeX, placeY,
		"Structures",
		obj_placeable,
		{
			item : newItem,
		}
	);
	
	return 1;
}
	
function CraftingRecipie(_item, _itemsRequired) constructor {
	item = _item;
	itemsRequired = _itemsRequired;
	
	//Checks if can craft an item
	//If cannot, it will return an array of the missing items
	static canCraft = function(craftInv = undefined) {
		var craftable = true;
		var missingItems = [];
		//the var "craftable" will remain true until a missing item is found
		for(var i=0; i<array_length(itemsRequired); i++) {
			var reqItem = itemsRequired[i];
			//If missing item, set craftable to false & add the required item to list of missing items
			//else, continue in the loop
			var search;
			if(is_array(craftInv))
				search = InvSearch(craftInv, reqItem.itemSpr, reqItem.amount);
			else
				search = InvSearchPlayer(reqItem.itemSpr, reqItem.amount);
			if(search == -1) {
				craftable = false;
				array_push(missingItems, reqItem);
			}
		}
		
		if(craftable)
			return true;
		else
			return missingItems;
	}
	
	static craftItem = function(craftInv = undefined) {
		var craftPossible;
		if(is_array(craftInv))
			craftPossible = canCraft(craftInv);
		else
			craftPossible = canCraft();
		if(craftPossible == true) {
			//Remove all items that are not needed
			for(var i=0; i<array_length(itemsRequired); i++) {
				var reqItem = itemsRequired[i];
				var neededItems = [];
				if(!is_array(craftInv))
					neededItems = InvGetPlayer(reqItem.itemSpr, reqItem.amount);
				else
					neededItems = InvGet(craftInv, reqItem.itemSpr, reqItem.amount);
				if(!is_array(neededItems))
					neededItems = array_create(1, neededItems)
				var amountToRemove = reqItem.amount;
				for(var j=0; j<array_length(neededItems); j++)  {
					var neededItem = neededItems[j];
					//Remove item from each stack
					amountToRemove = removeFromItem(neededItem, amountToRemove);
					//If there isn't any more of this required item to remove, then continue on to the next item.
					if(amountToRemove == 0)
						break;
				}
			}
			return duplicateItem(item);
		}
		else
			return craftPossible;
	}
	
}
	
function itemsAreSimilar(item, item2) {
	if(!isItem(item) || !isItem(item2))
		return false;
	return 
		item.itemSpr == item2.itemSpr &&
		item.name == item2.name &&
		item.desc == item2.desc &&
		instanceof(item) == instanceof(item2) &&
		item.animationType == item2.animationType;
}