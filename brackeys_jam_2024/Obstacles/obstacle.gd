class_name Obstacle
extends Area2D
@export var audio_stream : AudioStream
@onready var sound_manager: Node = $"../../../../../Sound_Manager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	
	if (body as CollisionObject2D).collision_mask & collision_layer == 0:
		return
	#Collision Test
	sound_manager.play_collision(audio_stream)
	#end
	GameState.end_game()
	collision_mask = 0
	print("some body entered ", body.name)
	pass # Replace with function body.

func _draw() -> void:
	#var rect := ($CollisionShape2D.shape as RectangleShape2D).get_rect() #Rect2(Vector2(0, 0), ($CollisionShape2D.shape as RectangleShape2D).size)
	#rect.position.y += $CollisionShape2D.position.y
	#draw_rect(rect, Color.BLUE_VIOLET)
	#draw_string(ThemeDB.fallback_font, Vector2(0, 0), str(collision_layer & 7), HORIZONTAL_ALIGNMENT_CENTER)
	pass
