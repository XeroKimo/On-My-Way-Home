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

#Test Sounds
func play_test_1():
	sine_test_01.play()

func play_test_2():
	sine_test_02.play()
	
func play_test_loop():
	sine_test_loop.play()
	
#Music and Ambiences
func play_calm_amb():
	$Ambiences/AMB_Calm_Gulls.play()
	$Ambiences/AMB_Calm_Waves.play()
	$Ambiences/AMB_Calm_Hiss.play()
	pass
	
func play_calm_mus():
	$Music/MUS_Calm.play()
	pass
	
func play_storm_amb():
	pass

#SFX
func play_footstep():
	$SFX/Player_FS.play()

func play_jump():
	$SFX/Player_Jump.play()

func play_slide():
	$SFX/Player_Slide.play()
	
func play_lane_switch_up():
	$SFX/Player_Lane_Switch_Up.play()

func play_lane_switch_down():
	$SFX/Player_Lane_Switch_Down.play()

#Collisions
func play_bonk_collision():
	$SFX/Collision_Bonk.play()
	
func play_splash_collision():
	$SFX/Collision_Splash.play()

func play_collision():
	play_test_1()
