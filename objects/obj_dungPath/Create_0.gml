//Always make ground first.
alarm_set(1, 6);

if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent) {
	noCreateEvent = false;
	return;
}
alarm_set(0, 5);