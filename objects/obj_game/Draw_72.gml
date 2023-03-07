//@description parallax scrolling background
if(layer_exists("BackgroundNear")) {
	layer_x("BackgroundNear", camera_get_view_x(view_camera[0]) * 0.5);
	layer_y("BackgroundNear", camera_get_view_y(view_camera[0]) * 0.5);
}
if(layer_exists("BackgroundFar1")) {
	layer_x("BackgroundFar1", camera_get_view_x(view_camera[0]) * 0.6);
	layer_y("BackgroundFar1", camera_get_view_y(view_camera[0]) * 0.6);
}
if(layer_exists("BackgroundFar2")) {
	layer_x("BackgroundFar2", camera_get_view_x(view_camera[0]) * 0.7);
	layer_y("BackgroundFar2", camera_get_view_y(view_camera[0]) * 0.7);
}
if(layer_exists("BackgroundFar3")) {
	layer_x("BackgroundFar3", camera_get_view_x(view_camera[0]) * 0.8);
	layer_y("BackgroundFar3", camera_get_view_y(view_camera[0]) * 0.8);
}
if(layer_exists("BackgroundFar4")) {
	layer_x("BackgroundFar4", camera_get_view_x(view_camera[0]) * 0.97);
	layer_y("BackgroundFar4", camera_get_view_y(view_camera[0]) * 0.97);
}