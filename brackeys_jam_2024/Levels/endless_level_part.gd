class_name EndlessLevelPart

extends Node2D

@export var _lane_proxies: Array
@export var _lane_width: int
@export var _cell_count: int

var _safe_path : Array
var _cells : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_safe_path.resize(_cell_count)
	_cells.resize(3 * _cell_count)
	pass # Replace with function body.

func initialize_positions_only(positions: Array):
	for i in _lane_proxies.size():
		_get_lane(i).position = positions[i]


func initialize(positions: Array, obstacles: Array, lava_nodes: Array, spawn_lava_nodes: bool = false):
	initialize_positions_only(positions)
	
	for i in _cells.size():
		var random_value = GameState.random.randf()
		if random_value <= 0.2:
			continue
		_cells[i] = obstacles[GameState.random.randi_range(0, obstacles.size() - 1)]
	
	for i in _safe_path.size():
		_safe_path[i] = GameState.random.randi_range(0, 2)
		_set_cell(_safe_path[i], i, null)
		
	for i in _cells.size():
		if _cells[i] == null:
			continue
		var child: Node2D = (_cells[i] as PackedScene).instantiate()
		var lane = i / _cell_count
		_get_lane(lane).add_child(child)
		child.position = Vector2((_lane_width / _cell_count) * (i % _cell_count) + (_lane_width / _cell_count) / 2, 0)
	

func _get_lane(index: int) -> Node2D:
	return get_node(_lane_proxies[index])
	
func _set_cell(lane: int, index: int, scene: PackedScene):
	_cells[lane * _cell_count + index] = scene
	
func _get_cell(lane: int, index: int) -> PackedScene:
	return _cells[lane * _cell_count + index]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
