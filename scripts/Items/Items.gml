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
	
function Axe(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum = itemAnimations.KNIFE_STAB) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum) constructor {}
function Pickaxe(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum = itemAnimations.KNIFE_STAB) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum) constructor {}

function PlaceableItem(itemSprite, itemAmount, dmg, itemName, itemDescription, sprite, rightClickFunction = function(){}, leftClickFunction = function(){}) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription) constructor {
	solid = true;
	static rightClickAction = rightClickFunction;
	static leftClickAction = leftClickFunction;
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
		"Instances",
		obj_placeable,
		{
			item : newItem,
		}
	);
	
	return 1;
}
	
function CraftingRecipie(_item, _itemsRequired, _toolsRequired = undefined) constructor {
	item = _item;
	itemsRequired = _itemsRequired;
	toolsRequired = _toolsRequired;
	itemsAndTools = itemsRequired;
	
	if(is_array(toolsRequired))
		itemsAndTools = array_concat(itemsRequired, toolsRequired)
	
	//Checks if can craft an item
	//If cannot, it will return an array of the missing items
	static canCraft = function(craftInv) {
		return InvSearchContainsOnly(craftInv, itemsAndTools);
	}
	
	static craftItem = function(craftInv) {
		var craftPossible = canCraft(craftInv);
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
	
function itemsAreSame(item, item2) {
	if(!isItem(item) || !isItem(item2))
		return false;
	return 
		item.itemSpr == item2.itemSpr &&
		item.name == item2.name &&
		item.desc == item2.desc &&
		instanceof(item) == instanceof(item2) &&
		item.animationType == item2.animationType;
}

function itemsAreSimilar(item, item2, includeAmount = false) {
	if(!isItem(item) || !isItem(item2))
		return false;
	var boolean = instanceof(item) == instanceof(item2);
	if(includeAmount)
		boolean = instanceof(item) == instanceof(item2) && item.amount == item2.amount;
	return boolean;
}
	
#region all items
function Workbench(amount = 1) : PlaceableItem(spr_woodBench,amount,0,"Workbench") constructor {

	desc = "A bench used for making a variety of things\nCrafting slots: " + string(4);
	
	placedSprite = spr_woodBenchP;
	static rightClickAction = function() {
		instance_create_depth(0,0,0,obj_craftingScreen, {numOfSlots : 4})
	};
	
	breakingTool = Axe;
	hp = 180;
	
	static leftClickAction = function(){}
	
	solid = true;
}
	
function WoodHatchet(amount = 1) : Axe(spr_woodHatchet,amount,2,"Wood Hatchet", "Hatchet that can cut down trees\nDamage: 2", itemAnimations.SWORD) constructor {
	
}
	
function Wood(amount = 1) : Item(spr_wood,amount,0,"Wood",":Resource:") constructor {}	

function WoodBlock(amount) : PlaceableItem(spr_woodBlock,amount,0,"Wood Block") constructor {
	placedSprite = spr_woodBlockP;
	breakingTool = Axe;
	hp = 120;
}
	
function WoodShaft(amount = 1) : Item(spr_woodShaft,amount,0,"Wood",":Resource:") constructor {}

#endregion all items