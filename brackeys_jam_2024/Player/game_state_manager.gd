extends Node

@onready var level_elements:= $"../Level Elements"
@onready var sound_manager: Node2D = $"../Sound_Manager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.on_game_ended.connect(on_game_ended)
	sound_manager.play_calm_amb()
	sound_manager.play_calm_mus()
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if !GameState.game_ended:
		return
	if event.is_action_pressed("jump"):
		GameState.reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_game_ended():
	level_elements.speed = 0
