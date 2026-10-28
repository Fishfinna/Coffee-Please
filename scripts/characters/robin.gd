extends Person

@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $Indicator
@onready var register = get_node("../Register")
@onready var pickup = get_node("../Pickup")
@onready var door = get_node("../Door")
@onready var ticket_board: TicketBoard = get_node("../../../Hud/TicketBoard")
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

# TODO: clean this up! make it re-usable
var id: String
var movement_speed = 150.0
var target: Node2D
var test = preload("res://dialog/test.dialogue")

func _on_interact():
	if interactable.is_interactable and not Dialog.active:
		indicator.play_audio()
		Dialog.show(test, "start", self)

func _ready() -> void:
	setup()
	_setup_avoidance()
	aquire_target(register)

func _setup_avoidance() -> void:
	navigation_agent_2d.avoidance_enabled = true
	navigation_agent_2d.radius = 14
	navigation_agent_2d.neighbor_distance = 150
	navigation_agent_2d.max_neighbors = 10
	navigation_agent_2d.time_horizon_agents = 1.5
	navigation_agent_2d.max_speed = movement_speed
	navigation_agent_2d.avoidance_priority = 1
	if not navigation_agent_2d.velocity_computed.is_connected(_on_navigation_agent_2d_velocity_computed):
		navigation_agent_2d.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)

func kick_off():
	aquire_target(register)

func setup() -> void:
	if id == "" or id == null:
		id = str(randi(), "_", Time.get_ticks_usec())
	call_deferred("seeker_setup")
	aquire_target(register)

func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func aquire_target(new_target: Node2D):
	target = new_target

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if target:
		navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished():
		move_and_slide()
		handle_collisions()
		return
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()
	handle_collisions()
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.lerp(safe_velocity, 0.25)
