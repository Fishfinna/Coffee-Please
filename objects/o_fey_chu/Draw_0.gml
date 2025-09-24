/// @description draw sprite
if (flip) {
	draw_sprite_ext(sprite_index, image_index, x, y, -1, 1, 0, c_white, 1);
} else {
	draw_self()
}