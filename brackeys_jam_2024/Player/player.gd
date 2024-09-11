class_name Player
extends RigidBody2D

var lane: int = 1
var old_lane: int = lane
@export var lane_offset: float

@export var jump_impulse_force: float = 350
@onready var ground_detector := $GroundDetector
var is_on_ground: bool = false

var collider: CollisionShape2D
var collider_shape : RectangleShape2D
#Percentage of the original collider's height, adjust when needed
@export var slide_collider_height: float = 0.5
@export var slide_duration_seconds: float = 0.5
var original_collider_y_pos: float
var original_collider_height: float
var sliding: bool = false

@onready var animator:= $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 1 << lane
	collider = $CollisionShape2D
	position.x = ProjectSettings.get_setting("global/lane_width") / ProjectSettings.get_setting("global/cell_count") / 2
	collider_shape = collider.shape as RectangleShape2D
	original_collider_height = collider_shape.size.y
	original_collider_y_pos = collider.position.y

func _input(event: InputEvent) -> void:
	if GameState.game_ended:
		return
		
	if event.is_action_pressed("lane_down") && lane < 2:
		lane += 1
		$Sound_Manager.play_lane_switch()
	if event.is_action_pressed("lane_up") && lane > 0:
		lane -= 1
		$Sound_Manager.play_lane_switch()
	if event.is_action_pressed("jump") && is_on_ground:
		stop_sliding()
		apply_central_impulse(Vector2.UP * jump_impulse_force)
		$Sound_Manager.play_jump()
		is_on_ground = false
	if event.is_action_pressed("slide") && !sliding && is_on_ground:
		start_sliding()
		$Sound_Manager.play_slide()
		await get_tree().create_timer(slide_duration_seconds).timeout
		stop_sliding()

func start_sliding():
	sliding = true
	collider_shape.size.y = original_collider_height * slide_collider_height
	collider.position.y = original_collider_y_pos + (1 - slide_collider_height) * original_collider_height / 2
	animator.stop()
	animator.play("slide")
	
	
func stop_sliding():
	collider_shape.size.y = original_collider_height
	collider.position.y = original_collider_y_pos
	animator.stop()
	animator.play("default_walk")
	sliding = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	is_on_ground = linear_velocity.y <= 0 && ground_detector.is_colliding()
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	collision_mask = 1 << lane
	position.y += lane_offset * (lane - old_lane)
	ground_detector.collision_mask = collision_mask
	old_lane = lane
