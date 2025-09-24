// Calculate the scaling factor based on the window size
var scale_factor = round(display_get_width() / 640);
scale_factor = min(scale_factor, round(display_get_height() / 360));

display_set_gui_size(640 * scale_factor, 360 * scale_factor);
