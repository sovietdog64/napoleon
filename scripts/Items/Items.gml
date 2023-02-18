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
function Workbench(_numOfCraftingSlots) : PlaceableItem(spr_woodBench,1,0,"Workbench") constructor {
	numOfCraftingSlots = _numOfCraftingSlots;
	desc = "A bench used for making a variety of things\nCrafting slots: " + string(numOfCraftingSlots);
	
	placedSprite = spr_woodBenchP;
	static rightClickAction = function() {
		instance_create_depth(0,0,0,obj_craftingScreen, {numOfSlots : 4})
	};
	
	static leftClickAction = function(){}
	
	solid = true;
}
#endregion

function placeItem(placeableItem, placeX, placeY) {
	if(!is_struct(placeableItem))
		return 0;
	if(!variable_struct_exists(placeableItem, "placedSprite"))
		return 0;
	var inst = instance_create_layer(
		placeX, placeY,
		"Structures",
		obj_placeable
	)
	inst.sprite_index = placeableItem.placedSprite;
	inst.rightClick = placeableItem.rightClickAction;
	inst.leftClick = placeableItem.leftClickAction;
	return 1;
}