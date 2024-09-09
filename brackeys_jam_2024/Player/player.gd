extends RigidBody2D

var lane: int = 1
var old_lane: int = lane
@export var lane_offset: float

const jump_impulse = 350
@onready var ground_detector := $GroundDetector
var is_on_ground: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 1 << lane
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lane_down") && lane < 2:
		lane += 1
	if event.is_action_pressed("lane_up") && lane > 0:
		lane -= 1
	if event.is_action_pressed("jump") && is_on_ground:
		apply_central_impulse(Vector2.UP * jump_impulse)
		is_on_ground = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	is_on_ground = linear_velocity.y <= 0 && ground_detector.is_colliding()
		
	pass
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	collision_mask = 1 << lane
	position.y += lane_offset * (lane - old_lane)
	ground_detector.collision_mask = collision_mask
	old_lane = lane
