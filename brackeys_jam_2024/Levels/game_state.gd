extends Node

signal on_game_ended;

var _generator:= RandomNumberGenerator.new()
var random: 
	get: return _generator

var _game_ended: bool = false
var game_ended: bool: 
	get: return _game_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_game() -> void:
	_game_ended = false
	get_tree().reload_current_scene()

func end_game() -> void:
	print("Game has ended")
	_game_ended = true
	on_game_ended.emit()
