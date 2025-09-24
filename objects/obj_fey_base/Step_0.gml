/// @description Walking controls with pixel snapping and room-bound clamping
// Movement input
var move_x = 0;
var move_y = 0;
if (keyboard_check(ord("W")) || keyboard_check(vk_up)) {
    move_y -= movement_spd;
}
if (keyboard_check(ord("S")) || keyboard_check(vk_down)) {
    move_y += movement_spd;
}
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) {
    move_x += movement_spd;
}
if (keyboard_check(ord("A")) || keyboard_check(vk_left)) {
    move_x -= movement_spd;
}
// Apply movement
x += move_x;
y += move_y;
// Snap to whole pixels
x = round(x);
y = round(y);
// Account for sprite offsets (so entire sprite stays visible)
var spr_w = sprite_width;
var spr_h = sprite_height;
var x_offset = sprite_xoffset;
var y_offset = sprite_yoffset;
// Calculate visible edges of the sprite
var left   = x_offset;
var right  = spr_w - x_offset;
var top    = y_offset;
var bottom = spr_h - y_offset;
// Clamp character inside the room
x = clamp(x, left, room_width - right);