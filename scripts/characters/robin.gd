extends Person

@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $Indicator

var test = preload("res://dialog/test.dialogue")

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable and not Dialog.active:
		indicator.play_audio()
		Dialog.show(test, "start", self)

<<<<<<< HEAD
func _ready() -> void:
	setup()
	_setup_avoidance()
	aquire_target(register)

func _setup_avoidance() -> void:
	navigation_agent_2d.avoidance_enabled = true
	navigation_agent_2d.radius = 1
	navigation_agent_2d.neighbor_distance = 10
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

=======
>>>>>>> parent of 277a61e (started on the customer logic)
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()
	handle_collisions()
