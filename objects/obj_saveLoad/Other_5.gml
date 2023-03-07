/// @description Save s	tate of room when room ended.
if(room == rm_init)
	return;

if(!skipRoomSave) {
	saveRoom2();
}
skipRoomSave = false;