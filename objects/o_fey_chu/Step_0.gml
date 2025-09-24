/// @description walking controls with speed and boundaries
var move_y = 0;
var move_x = 0;

if (keyboard_check(ord("W")) || keyboard_check(vk_up)) {
    move_y -= 6;
}
if (keyboard_check(ord("S")) || keyboard_check(vk_down)) {
    move_y += 6;
}
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) {
    move_x += 6;
}
if (keyboard_check(ord("A")) || keyboard_check(vk_left)) {
    move_x -= 6;
}

y += move_y;
x += move_x;

var half_width = sprite_width / 2;
var half_height = sprite_height / 2;

x = clamp(x, half_width, room_width - half_width);
y = clamp(y, half_height, room_height - half_height);

flip = move_x > 0 || (move_x == 0 && flip);