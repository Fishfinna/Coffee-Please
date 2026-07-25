class_name Staff
extends RefCounted

var id: StringName
var display_name: String
var unlocked: bool
var charm: int
var speed: int
var skill: int
var xp

func _init(
	p_id: StringName,
	p_display_name: String,
	p_charm: int,
	p_speed: int,
	p_skill: int,
	p_xp: int,
	p_unlocked: bool = false,
) -> void:
	id = p_id
	display_name = p_display_name
	charm = p_charm
	speed = p_speed
	skill = p_skill
	p_xp = p_xp
	unlocked = p_unlocked
