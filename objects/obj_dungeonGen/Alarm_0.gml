var allRooms = [];

with(obj_dungRoom)
	array_push(allRooms, id);

var roomCount = array_length(allRooms);
var numOfEnemyRooms = irandom_range(roomCount/2, roomCount*0.7);
var numOfMerchants = 1;
if(roomCount - numOfEnemyRooms >= 2)
	numOfMerchants = choose(1, 2);
var numOfChests = irandom_range(1, roomCount - (numOfEnemyRooms+numOfMerchants))

var rm = undefined;
repeat(numOfEnemyRooms) {
	while(rm == undefined || rm.roomType != dungRoomTypes.NONE)
		rm = randomValueFromArray(allRooms);
	
	rm.roomType = dungRoomTypes.ENEMY;
}

var rm = undefined;
repeat(numOfMerchants) {
	while(rm == undefined || rm.roomType != dungRoomTypes.NONE)
		rm = randomValueFromArray(allRooms);
	
	rm.roomType = dungRoomTypes.MERCHANT;
}

var rm = undefined;
repeat(numOfChests) {
	while(rm == undefined || rm.roomType != dungRoomTypes.NONE)
		rm = randomValueFromArray(allRooms);
	
	rm.roomType = dungRoomTypes.CHEST;
}