extends CharacterBody2D

@export var speed = 250

var target = position

var last_x := 0
var last_y := 0

func get_input():
	if Input.is_action_just_pressed("left"):
		last_x = -1
	elif Input.is_action_just_pressed("right"):
		last_x = 1

	if Input.is_action_just_pressed("up"):
		last_y = -1
	elif Input.is_action_just_pressed("down"):
		last_y = 1

	var x := 0
	var y := 0

	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		x = last_x

	if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		y = last_y

	velocity = Vector2(x, y).normalized() * speed


func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
