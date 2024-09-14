class_name EndlessLevelPart

extends Node2D

@export var _lane_proxies: Array
@export var _obstacle_relative_offset: Array = [0.0, 0.0, 0.0]
@onready var _lane_width: int = ProjectSettings.get_setting("global/lane_width")
@onready var _cell_count: int= ProjectSettings.get_setting("global/cell_count")

var _safe_path : Array
var _cells : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_cells.resize(3 * _cell_count)
	pass # Replace with function body.

func initialize_positions_only(positions: Array):
	for i in _lane_proxies.size():
		_get_lane(i).position = positions[i]


func initialize(positions: Array, obstacles: Array, lava_nodes: Array, spawn_lava_nodes: bool = false):
	initialize_positions_only(positions)
	
	_safe_path.resize(_cell_count)
	for i in _cells.size():
		var random_value = GameState.random.randf()
		if random_value <= 1 - ProjectSettings.get_setting("global/obstalce_spawn_chance"):
			continue
		_cells[i] = obstacles[GameState.random.randi_range(0, obstacles.size() - 1)]
	
	for i in _safe_path.size():
		_safe_path[i] = GameState.random.randi_range(0, 2)
		_set_cell(_safe_path[i], i, null)
		assert(_get_cell(_safe_path[i], i) == null)
		
	for i in _cells.size():
		if _cells[i] == null:
			continue
		_spawn_obstacle(_cells[i], _cell_to_lane(i), _cell_to_column(i))
	
	if spawn_lava_nodes:
		spawn_lava_nodes(lava_nodes)
	
	
func spawn_lava_nodes(lava_nodes: Array):
		for i in _cells.size():
			if _cells[i] != null:
				continue
			if _is_safe_cell(i):
				continue
			_cells[i] = lava_nodes[0];
			_spawn_obstacle(_cells[i], _cell_to_lane(i), _cell_to_column(i))
			

func _spawn_obstacle(scene: PackedScene, lane: int, column: int):
	var child: = scene.instantiate() as Obstacle
	child.collision_layer |= 1 << lane
	_get_lane(lane).add_child(child)
	child.position = Vector2((_lane_width / _cell_count) * (column % _cell_count) + (_lane_width / _cell_count) / 2 + (_lane_width / _cell_count) * _obstacle_relative_offset[lane], 0)
	

func remove_lava_nodes():
	for i in _lane_proxies.size():
		for child in _get_lane(i).get_children():
			if child.has_meta("type") && child.get_meta("type") == "lava":
				child.queue_free()
		

func _get_lane(index: int) -> Node2D:
	return get_node(_lane_proxies[index])
	
func _set_cell(lane: int, index: int, scene: PackedScene):
	_cells[lane * _cell_count + index] = scene
	
func _get_cell(lane: int, index: int) -> PackedScene:
	return _cells[lane * _cell_count + index]
	
func _is_safe_cell(index: int) -> bool:
	var lane = index / _cell_count;
	return _cells[index] == null && _safe_path[index % _cell_count] == lane

func _draw() -> void:
	#var rect = Rect2(Vector2(0, 0), Vector2(1920,1280))
	#draw_rect(rect, Color.ALICE_BLUE, false)
	#for i in _safe_path.size():
		#draw_string(ThemeDB.fallback_font, _cell_to_position(_safe_path[i], i), "Is Safe", HORIZONTAL_ALIGNMENT_CENTER)
	pass

func _cell_to_lane(index: int) -> int:
	return index / _cell_count
	
func _cell_to_column(index: int) -> int:
	return index % _cell_count

func _cell_to_position_cell_only(index: int) ->Vector2:
	return _cell_to_position(_cell_to_lane(index), _cell_to_column(index))

func _cell_to_position(lane: int, column: int) ->Vector2:
	return Vector2((_lane_width / _cell_count) * column + (_lane_width / _cell_count) / 2, _get_lane(lane).global_position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
