/// @description walking controls

var _move_y = 0;
var _move_x = 0;
if (keyboard_check(ord("W")) || keyboard_check(vk_up)) {
    _move_y -= 3;
}

if (keyboard_check(ord("S")) || keyboard_check(vk_down)) {
    _move_y += 3;
}

if (keyboard_check(ord("D")) || keyboard_check(vk_right)) {
    _move_x += 3;
}

if (keyboard_check(ord("A")) || keyboard_check(vk_left)) {
    _move_x -= 3;
}

y += _move_y
x += _move_x

flip = _move_x > 0 ||(_move_x == 0 && flip)
