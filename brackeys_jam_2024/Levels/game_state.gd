extends Node

signal on_game_ended;

var _generator:= RandomNumberGenerator.new()
var random: 
	get: return _generator

var _game_ended: bool = false
var game_ended: bool: 
	get: return _game_ended
var invincible_mode: bool = false

var distance: float
var score: int:
	get: return (distance / 100) as int 
var highscore: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_game() -> void:
	_game_ended = false
	distance = 0
	get_tree().reload_current_scene()

func end_game() -> void:
	if invincible_mode:
		return
	print("Distance traveled: ", score)
	if score > highscore:
		highscore = score
	_game_ended = true
	on_game_ended.emit()
