extends Node2D
@onready var sound_manager: Node2D = $Sound_Manager

#audioserver stuff
var sfx_bus = AudioServer.get_bus_index("SFX")
var mus_bus = AudioServer.get_bus_index("MUS")
var amb_bus = AudioServer.get_bus_index("AMB")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#AudioServer.set_bus_mute(sfx_bus, false)
	#AudioServer.set_bus_mute(mus_bus, false)
	#AudioServer.set_bus_mute(amb_bus, false)
	sound_manager.play_menu_mus()
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		sound_manager.play_menu_start()
		get_tree().change_scene_to_file("res://Levels/Endless_Level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
