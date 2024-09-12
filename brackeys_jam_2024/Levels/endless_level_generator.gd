extends Node2D

@export var background: PackedScene
@export var obstacles: Array
@export var lava_obstacles: Array
@onready var lanes = [$"Lane 1", $"Lane 2", $"Lane 3"]

@export var initial_speed: float = 300
@export var max_speed: float = 600
@export var acceleration: float = 10
@onready var sky:= $Sky

var speed: float
var level_parts: Array
var lane_width: float
const parts_buffer : int = 2

var storm_brewing: bool = false
var storm_timer_seconds: float
var previous_storm_timer_seconds: float
@export var pre_storm_duration_seconds: float = 5
@export var storm_duration_seconds: float = 15
var storm_in_progress: bool:
	get: return storm_brewing && storm_timer_seconds >= 0 && storm_timer_seconds <= storm_duration_seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lane_width = ProjectSettings.get_setting("global/lane_width")
	speed = initial_speed
	
	var child = background.instantiate() as EndlessLevelPart
	add_child(child)
	level_parts.push_back(child)
	for i in parts_buffer * 2:
		child = background.instantiate() as EndlessLevelPart
		add_child(child)
		level_parts.push_back(child)
		child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, 
			(lanes[2] as Node2D).position], obstacles, lava_obstacles)
		child.position.x = lane_width * (i + 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.game_ended:
		return
	for part: EndlessLevelPart in level_parts:
		part.position.x -= speed * delta
	_spawn_new_part()
	speed += acceleration * delta
	
	if !storm_brewing && GameState.random.randf() <= 0.2:
		storm_brewing = true
		print("A storm is brewing")
		storm_timer_seconds = -pre_storm_duration_seconds
		sky.play("transition")
		sky.speed_scale = 1.0 / pre_storm_duration_seconds
	else:
		previous_storm_timer_seconds = storm_timer_seconds
		storm_timer_seconds += delta
		if previous_storm_timer_seconds < 0 && storm_timer_seconds >=0:
			_begin_storm()
		if storm_timer_seconds >= storm_duration_seconds && previous_storm_timer_seconds < storm_duration_seconds:
			_end_storm()
		if storm_timer_seconds >= storm_duration_seconds + pre_storm_duration_seconds:
			print("Storm has subsided")
			sky.play("inactive")
			storm_brewing = false
	pass
	
func _begin_storm():
	print("Storm has started")
	sky.play("active")
	for p in level_parts:
		var part = p as EndlessLevelPart
		if part.position.x >= lane_width:
			part.spawn_lava_nodes(lava_obstacles)
	pass
	
func _end_storm():
	print("Storm has ended")
	sky.play_backwards("transition")
	for p in level_parts:
		var part = p as EndlessLevelPart
		part.remove_lava_nodes()
	pass
	
func _rotate_parts_array():
	for i in level_parts.size() - 1:
		var temp = level_parts[i]
		level_parts[i] = level_parts[i + 1]
		level_parts[i + 1] = temp
	
func _spawn_new_part():
	if (level_parts[0] as EndlessLevelPart).position.x > -lane_width * parts_buffer:
		return
	_rotate_parts_array()
	(level_parts.back() as EndlessLevelPart).queue_free()
	level_parts.pop_back()
	var child = background.instantiate() as EndlessLevelPart
	add_child(child)
	child.position.x = (level_parts.back() as EndlessLevelPart).position.x + lane_width
	child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, 
	(lanes[2] as Node2D).position], obstacles, lava_obstacles, storm_in_progress)

	level_parts.push_back(child)
