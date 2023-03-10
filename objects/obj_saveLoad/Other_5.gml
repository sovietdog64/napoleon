/// @description Save s	tate of room when room ended.
if(room == rm_init || room == rm_mainMenu)
	return;

if(!skipRoomSave) {
	saveRoom();
}
skipRoomSave = false;