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

function PlaceableItem(itemSprite, itemAmount, dmg, itemName, itemDescription, _placedStruct) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription) constructor {
	placedStruct = _placedStruct;
}


#region all item constructors
function Workbench(numOfCraftingSlots) : PlaceableItem() constructor {
	
}
#endregion