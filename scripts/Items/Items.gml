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


#region all item constructors

///@param {array} outputArray An optional param. Use it if you want to run script_execute() on it.
function Workbench(outputArray = undefined) : PlaceableItem(spr_woodBench,1,0,"Workbench") constructor {
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
	
function WoodHatchet(outputArray = undefined) : Item(spr_woodHatchet,1,2,"Wood Hatchet", "Hatchet that can cut down trees\nDamage: 2", itemAnimations.KNIFE_STAB) constructor {
	if(is_array(outputArray)) {
		outputArray[0] = new WoodHatchet();
		return;
	}
}
	
function Wood(outputArray = undefined) : Item(spr_wood,1,0,"Wood",":Resource:") constructor {
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
	instance_create_layer(
		placeX, placeY,
		"Structures",
		obj_placeable,
		{
			item : placeableItem,
		}
	);
	
	return 1;
}