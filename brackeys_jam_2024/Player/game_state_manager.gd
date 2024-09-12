extends Node

@onready var level_elements:= $"../Level Elements"
@onready var sound_manager: Node2D = $"../Sound_Manager"
@export var invincible_mode: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_manager.play_calm_amb()
	sound_manager.play_calm_mus()
	GameState.invincible_mode = invincible_mode
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if !GameState.game_ended:
		return
	if event.is_action_pressed("jump"):
		GameState.reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
