extends Node2D

@export var background: PackedScene
@export var obstacles: Array
@export var lava_obstacles: Array
@onready var lanes = [$"Level Elements/Lane 1", $"Level Elements/Lane 2", $"Level Elements/Lane 3"]

@export var initial_speed: float = 300
@export var max_speed: float = 600
@export var acceleration: float = 10

@onready var background_container:= $"Level Elements/Background"
@onready var sky:= $"Level Elements/Sky/Background"
@onready var clouds:= $"Level Elements/Sky/Clouds"
@onready var rain:= $"Level Elements/Sky/Rain"
@onready var flash:= $"Level Elements/Flash"

#Sound
@onready var sound_manager: Node2D = $Sound_Manager
var collision_played : bool = false
#Sound

var speed: float
var level_parts: Array
var lane_width: float
const parts_buffer : int = 2

var storm_brewing: bool = false
var storm_timer_seconds: float
var lightning_timer: float
var previous_storm_timer_seconds: float
@export var pre_storm_duration_seconds: float = 5
@export var storm_duration_seconds: float = 15
var storm_in_progress: bool:
	get: return storm_brewing && storm_timer_seconds >= 0 && storm_timer_seconds <= storm_duration_seconds
@onready var storm_brewing_timer:= $"Level Elements/StormBrewingTimer"

@export var shadow_array: Array
@export var shadow_heights: Array

# Called when the node enters the scene tree for the first time.
func _on_game_ended():
	await get_tree().create_timer(0.5).timeout
	$GameOver.visible = true
	sound_manager.play_game_over()

func _ready() -> void:
	GameState.on_game_ended.connect(_on_game_ended)
	lane_width = ProjectSettings.get_setting("global/lane_width")
	speed = initial_speed
	
	var child = background.instantiate() as EndlessLevelPart
	background_container.add_child(child)
	level_parts.push_back(child)
	
	for i in parts_buffer * 2:
		child = background.instantiate() as EndlessLevelPart
		background_container.add_child(child)
		level_parts.push_back(child)
		child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, 
			(lanes[2] as Node2D).position], obstacles, lava_obstacles)
		child.position.x = lane_width * (i + 1)
	pass # Replace with function body.

func free() -> void:
	GameState.on_game_ended.disconnect(_on_game_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.game_ended:
		return
	
	var player_shadow:= $"Level Elements/Player Shadow"
	var player:=$"Level Elements/Player"
	player_shadow.position.x = player.position.x
	player_shadow.position.y = lanes[player.lane].position.y - 15
	var texture: Texture2D = shadow_array[0] as Texture2D
	var player_height = (lanes[player.lane].position.y - player.position.y)
	#print(player_height)
	for i in shadow_array.size() - 1:
		if player_height >= (shadow_heights[i] as float):
			texture = shadow_array[i + 1]
	player_shadow.texture = texture
	var distance_traveled =  speed * delta
	for part: EndlessLevelPart in level_parts:
		part.position.x -= distance_traveled
		
	GameState.distance += distance_traveled
	_spawn_new_part()
	speed += acceleration * delta
	
	#print(storm_brewing_timer.time_left)
	if !storm_brewing && storm_brewing_timer.time_left == 0:
		print("Trying to start a storm")
		#storm_brewing_timer.start()
		#storm_brewing = GameState.random.randf() <= 0.2
		storm_brewing = true
		sound_manager.play_distant_thunder()
		print("A storm is brewing")
		storm_timer_seconds = -pre_storm_duration_seconds
		sky.play("transition")
		clouds.play("transition")
		sky.speed_scale = 1.0 / pre_storm_duration_seconds
		clouds.speed_scale = 1.0 / pre_storm_duration_seconds
	
	if storm_in_progress:
		lightning_timer += delta
	
	if storm_brewing:
		previous_storm_timer_seconds = storm_timer_seconds
		storm_timer_seconds += delta
		if previous_storm_timer_seconds < 0 && storm_timer_seconds >=0:
			_begin_storm()
		if storm_timer_seconds >= storm_duration_seconds && previous_storm_timer_seconds < storm_duration_seconds:
			_end_storm()
		if storm_timer_seconds >= storm_duration_seconds + pre_storm_duration_seconds:
			print("Storm has subsided")
			sky.play("inactive")
			clouds.play("inactive")
			storm_brewing = false
			storm_brewing_timer.start()
		if lightning_timer >= 3:
			_play_lightning()
	pass
	
func _begin_storm():
	print("Storm has started")
	sound_manager.play_thunder()
	#delete this if we hate it
	sound_manager.play_storm_mus()
	sound_manager.play_storm_amb()
	sky.play("active")
	clouds.play("active")
	rain.visible = true
	_play_lightning()
	for p in level_parts:
		var part = p as EndlessLevelPart
		if part.position.x >= lane_width:
			part.spawn_lava_nodes(lava_obstacles)
	pass
	
	_full_screen_flash()
	
func _play_lightning():
	lightning_timer = 0
	sky.play("lightning")
	sky.speed_scale = 1.0
	await sky.animation_finished
	sky.play("active")
	sky.speed_scale = 1.0 / pre_storm_duration_seconds
	
func _end_storm():
	print("Storm has ended")
	sky.speed_scale = 1.0
	clouds.speed_scale = 1.0
	sky.play_backwards("transition")
	clouds.play_backwards("transition")
	sound_manager.play_calm_mus()
	sound_manager.play_calm_amb()
	rain.visible = false
	for p in level_parts:
		var part = p as EndlessLevelPart
		part.remove_lava_nodes()
	pass
	
	_full_screen_flash()
	
func _full_screen_flash():
	flash.visible = true
	await get_tree().create_timer(0.1).timeout
	flash.visible = false
	await get_tree().create_timer(0.05).timeout
	flash.visible = true
	await get_tree().create_timer(0.05).timeout
	flash.visible = false
	
	
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
	background_container.add_child(child)
	child.position.x = (level_parts.back() as EndlessLevelPart).position.x + lane_width
	child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, 
	(lanes[2] as Node2D).position], obstacles, lava_obstacles, storm_in_progress)

	level_parts.push_back(child)
