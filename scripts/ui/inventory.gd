extends Control
class_name InventoryComponent

@onready var left: Control = $left
@onready var left_focus: NinePatchRect = $left/focus
@onready var left_icon: Sprite2D = $left/Sprite2D
@onready var left_label: Label = $left/Label
@onready var right: Control = $right
@onready var right_focus: NinePatchRect = $right/focus
@onready var right_icon: Sprite2D = $right/Sprite2D
@onready var right_label: Label = $right/Label
@onready var switch_sound: AudioStreamPlayer = $SwitchSound

const FOCUS_MOVE_DURATION := 0.15
const FOCUS_RAISE_OFFSET := -8.0

var _left_rest_y: float
var _right_rest_y: float
var _left_tween: Tween
var _right_tween: Tween

func _ready() -> void:
	_left_rest_y = left.position.y
	_right_rest_y = right.position.y

	Inventory.item_added.connect(_on_item_added)
	Inventory.item_removed.connect(_on_item_removed)
	Inventory.focus_changed.connect(_on_focus_changed)

	_refresh_slot_display(0)
	_refresh_slot_display(1)
	_apply_focus_visual(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_swap_focus"):
		Inventory.set_focus(1 - Inventory.focused_slot)
	elif event.is_action_pressed("inventory_slot_left"):
		Inventory.set_focus(0)
	elif event.is_action_pressed("inventory_slot_right"):
		Inventory.set_focus(1)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Inventory.set_focus(wrapi(Inventory.focused_slot - 1, 0, len(Inventory.inventory)))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Inventory.set_focus(wrapi(Inventory.focused_slot + 1, 0, len(Inventory.inventory)))

func _on_item_added(slot_index: int, _item: Item) -> void:
	_refresh_slot_display(slot_index)

func _on_item_removed(slot_index) -> void:
	_refresh_slot_display(slot_index)
	
func _on_focus_changed(_new_slot: int) -> void:
	switch_sound.play()
	_apply_focus_visual()

func _apply_focus_visual(instant: bool = false) -> void:
	var left_active := Inventory.focused_slot == 0
	var right_active := Inventory.focused_slot == 1
	var left_target_y := _left_rest_y + (FOCUS_RAISE_OFFSET if left_active else 0.0)
	var right_target_y := _right_rest_y + (FOCUS_RAISE_OFFSET if right_active else 0.0)
	var left_target_alpha := 1.0 if left_active else 0.0
	var right_target_alpha := 1.0 if right_active else 0.0

	_refresh_slot_display(0)
	_refresh_slot_display(1)

	if instant:
		left.position.y = left_target_y
		right.position.y = right_target_y
		left_focus.modulate.a = left_target_alpha
		right_focus.modulate.a = right_target_alpha
		return

	if _left_tween:
		_left_tween.kill()
	_left_tween = create_tween()
	_left_tween.set_parallel(true)
	_left_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_left_tween.tween_property(left, "position:y", left_target_y, FOCUS_MOVE_DURATION)
	_left_tween.tween_property(left_focus, "modulate:a", left_target_alpha, FOCUS_MOVE_DURATION)

	if _right_tween:
		_right_tween.kill()
	_right_tween = create_tween()
	_right_tween.set_parallel(true)
	_right_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_right_tween.tween_property(right, "position:y", right_target_y, FOCUS_MOVE_DURATION)
	_right_tween.tween_property(right_focus, "modulate:a", right_target_alpha, FOCUS_MOVE_DURATION)
	
func _refresh_slot_display(slot_index: int) -> void:
	var item: Item = Inventory.inventory[slot_index]
	var icon: Sprite2D = left_icon if slot_index == 0 else right_icon
	var label: Label = left_label if slot_index == 0 else right_label
	var is_focused := slot_index == Inventory.focused_slot

	if item == null:
		icon.texture = null
		icon.visible = false
		label.text = ""
	else:
		icon.texture = load(item.image)
		icon.visible = true
		label.text = item.display_name.to_lower()

	label.visible = is_focused and item != null
