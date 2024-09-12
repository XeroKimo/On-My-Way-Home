class_name Obstacle
extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if (body as CollisionObject2D).collision_mask & collision_layer == 0:
		return

	GameState.end_game()
	print("some body entered ", body.name)
	pass # Replace with function body.
