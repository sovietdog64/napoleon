prevPlayerEntered = false;

itemsSold = [];
itemPrices = [];
chestItems = [];
enemy1Obj = obj_skeleGuard;
enemy2Obj = obj_skeleGuard;
enemy3Obj = obj_skeleGuard;

switch(sprite_index) {
	case spr_dungeon: {
		itemsSold = [new Iron(choose(1, 5)), new IronSword(), new IronHatchet(), new BasicWand()];
		itemPrices = [20, 70, 30];
		chestItems = [new String(irandom_range(1, 4)), new Iron(irandom_range(1, 4))];
		enemy1Obj = obj_skeleGuard;
	} break;
}