extends Node2D
@onready var sine_test_01: AudioStreamPlayer = $Test_Sounds/Sine_test_01
@onready var sine_test_02: AudioStreamPlayer = $Test_Sounds/Sine_test_02
@onready var sine_test_loop: AudioStreamPlayer = $Test_Sounds/Sine_test_loop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _play_test_1():
	sine_test_01.play()

func _play_test_2():
	sine_test_02.play()
	
func _play_test_loop():
	sine_test_loop.play()
