if (instance_exists(target)) {
    var cam_x = floor(target.x - camera_width / 2);
    var cam_y = floor(target.y - camera_height / 2);
    cam_x = clamp(cam_x, 0, room_width - camera_width);
    cam_y = clamp(cam_y, 0, room_height - camera_height);
    camera_set_view_pos(cam, cam_x, cam_y);
}

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}