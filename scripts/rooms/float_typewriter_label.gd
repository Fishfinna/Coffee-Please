extends Control

@export var word_delay: float = 0.12
@export var float_distance: float = 20.0
@export var anim_duration: float = 0.35
@export var paragraph_spacing: float = 12.0
@export var start_on_ready: bool = true
@export var source_label_path: NodePath
@export var skip_action: String = "ui_accept"

@onready var button: Button = $Button
@onready var container: VBoxContainer = $VBoxContainer

var default_color: Color = Color.WHITE
var _total_words := 0
var _finished_words := 0
var _pending_timers: Array = []
var _active_tweens: Array = []


func _ready() -> void:
	if source_label_path != NodePath(""):
		var src := get_node(source_label_path)
		reveal_from_node(src)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(skip_action) and _finished_words < _total_words:
		skip_to_end()
		get_viewport().set_input_as_handled()

func reveal_finished():
	button.visible = true


func reveal_from_node(source: Node, hide_source: bool = true) -> void:
	var content := ""

	if source is RichTextLabel:
		var rtl := source as RichTextLabel
		content = rtl.text
		default_color = rtl.get_theme_color("default_color")

	elif source is Label:
		var lbl := source as Label
		content = lbl.text

		if lbl.label_settings and lbl.label_settings.font_color:
			default_color = lbl.label_settings.font_color
		else:
			default_color = lbl.get_theme_color("font_color")

	elif "text" in source:
		content = source.text

	else:
		push_warning("reveal_from_node: source has no readable text")
		return

	if hide_source:
		source.visible = false

	reveal_text(content)


func reveal_text(paragraph_text: String) -> void:
	for child in container.get_children():
		child.queue_free()

	_pending_timers.clear()
	_active_tweens.clear()

	var paragraphs := paragraph_text.strip_edges().split("\n")
	var lines: Array = []
	var total_words := 0

	for paragraph in paragraphs:
		var trimmed := paragraph.strip_edges()

		if trimmed == "":
			lines.append([])
			continue

		var words := _split_bbcode_words(trimmed)
		lines.append(words)
		total_words += words.size()

	_total_words = total_words
	_finished_words = 0

	if total_words == 0:
		reveal_finished()
		return

	var word_index := 0

	for words in lines:
		var line := HBoxContainer.new()
		container.add_child(line)

		if words.is_empty():
			line.custom_minimum_size.y = paragraph_spacing
			continue

		for word in words:
			_spawn_word(word, word_index, line)
			word_index += 1


func skip_to_end() -> void:
	for timer in _pending_timers:
		if is_instance_valid(timer):
			timer.time_left = 0.0

	for tween in _active_tweens:
		if is_instance_valid(tween) and tween.is_valid():
			tween.custom_step(1000.0)

	_pending_timers.clear()
	_active_tweens.clear()


func _split_bbcode_words(text: String) -> Array:
	var result: Array = []
	var open_tags: Array = []
	var word_start_tags: Array = []
	var current_word := ""
	var i := 0

	while i < text.length():
		var c := text[i]

		if c == "[":
			var end := text.find("]", i)

			if end == -1:
				current_word += c
				i += 1
				continue

			var tag := text.substr(i, end - i + 1)
			var inner := text.substr(i + 1, end - i - 1)

			if inner.begins_with("/"):
				if current_word != "":
					current_word += tag
				if open_tags.size() > 0:
					open_tags.pop_back()
			else:
				if current_word != "":
					current_word += tag
				open_tags.append(tag)

			i = end + 1
			continue

		if c == " ":
			if current_word != "":
				result.append(_finish_word(current_word, word_start_tags, open_tags))
				current_word = ""
			i += 1
			continue

		if current_word == "":
			word_start_tags = open_tags.duplicate()

		current_word += c
		i += 1

	if current_word != "":
		result.append(_finish_word(current_word, word_start_tags, open_tags))

	return result


func _finish_word(word: String, start_tags: Array, open_tags: Array) -> String:
	var prefix := ""
	for tag in start_tags:
		prefix += tag

	var suffix := ""
	for i in range(open_tags.size() - 1, -1, -1):
		suffix += _closing_tag(open_tags[i])

	return prefix + word + suffix


func _closing_tag(tag: String) -> String:
	var inner := tag.substr(1, tag.length() - 2)
	var tag_name := inner.split("=")[0]
	return "[/" + tag_name + "]"


func _spawn_word(word: String, index: int, line: HBoxContainer) -> void:
	var slot := Control.new()
	line.add_child(slot)

	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.scroll_active = false
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.add_theme_color_override("default_color", default_color)
	label.text = word
	slot.add_child(label)

	await get_tree().process_frame
	slot.custom_minimum_size = label.size

	label.modulate.a = 0.0
	label.position.y = float_distance

	if index > 0:
		var delay_timer := get_tree().create_timer(index * word_delay)
		_pending_timers.append(delay_timer)
		await delay_timer.timeout

	if not is_instance_valid(label):
		_word_finished()
		return

	var tween := create_tween()
	_active_tweens.append(tween)
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 1.0, anim_duration)
	tween.tween_property(label, "position:y", 0.0, anim_duration)

	await tween.finished
	_word_finished()


func _word_finished() -> void:
	_finished_words += 1
	if _finished_words >= _total_words:
		reveal_finished()
