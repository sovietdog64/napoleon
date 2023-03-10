/// @description Save s	tate of room when room ended.
if(room == rm_init || room == rm_mainMenu || room == rm_cutscene)
	return;

if(!skipRoomSave) {
	saveRoom();
}
skipRoomSave = false;