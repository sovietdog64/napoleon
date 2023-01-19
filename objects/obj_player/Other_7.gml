/// @description Reset animation
var heldItem = global.hotbarItems[global.equippedItem];
if(!isItem(heldItem)) 
	return;
if(heldItem.itemSpr == spr_boxingGloves) {
	sprite_index = spr_playerBoxingGloves;
} else {
	sprite_index = spr_player;
}