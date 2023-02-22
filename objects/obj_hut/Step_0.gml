// Inherit the parent event
event_inherited();

if(instance_exists(creatorID) && place_meeting(x, y, obj_house) || place_meeting(x, y, obj_villPath)) {
	var creator = creatorID;
	while(variable_instance_exists(creator, "creatorID"))
		creator = creator.creatorID;
	if(instance_exists(creator))
		creator.destroy = true;
}