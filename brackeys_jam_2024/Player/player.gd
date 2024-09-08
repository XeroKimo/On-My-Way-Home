extends RigidBody2D

var lane: int = 1
var down_velocity: float
@export var lane_offset: float
const jump_impulse = 350
var up_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 1 << lane
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lane_down") && lane < 2:
		position.y += lane_offset
		lane += 1
	if event.is_action_pressed("lane_up") && lane > 0:
		position.y -= lane_offset
		lane -= 1
	if event.is_action_pressed("jump"):
		apply_central_impulse(Vector2.UP * jump_impulse)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	collision_mask = 1 << lane
