class_name BetaLevelMovement

extends Node2D

@export var speed: float = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.game_ended:
		return
	position.x -= speed * delta
	pass
