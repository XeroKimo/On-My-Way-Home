extends Node2D

@export var background: PackedScene
@export var obstacles: Array
@onready var lanes = [$"Lane 1", $"Lane 2", $"Lane 3"]

@export var initial_speed: float = 300
@export var max_speed: float = 600
@export var acceleration: float = 10

var speed: float
var level_parts: Array
var lane_width: float
const parts_buffer : int = 2

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
		child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, (lanes[2] as Node2D).position], obstacles, Array())
		child.position.x = lane_width * (i + 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for part: EndlessLevelPart in level_parts:
		part.position.x -= speed * delta
	_spawn_new_part()
	if !GameState.game_ended:
		speed += acceleration * delta
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
	level_parts.pop_back()
	var child = background.instantiate() as EndlessLevelPart
	add_child(child)
	child.position.x = (level_parts.back() as EndlessLevelPart).position.x + lane_width
	child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, (lanes[2] as Node2D).position], obstacles, Array())

	level_parts.push_back(child)
