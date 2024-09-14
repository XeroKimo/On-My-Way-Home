extends Node2D
@onready var sine_test_01: AudioStreamPlayer = $Test_Sounds/Sine_test_01
@onready var sine_test_02: AudioStreamPlayer = $Test_Sounds/Sine_test_02
@onready var sine_test_loop: AudioStreamPlayer = $Test_Sounds/Sine_test_loop

var mus_bus = AudioServer.get_bus_index("MUS")
var sfx_bus = AudioServer.get_bus_index("SFX")
var amb_bus = AudioServer.get_bus_index("AMB")

signal collision_played
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
func play_game_over():
	#stops
	#await $SFX/Game_Over.finished
	$Ambiences/AMB_Calm_Gulls.stop()
	$Ambiences/AMB_Calm_Waves.stop()
	$Ambiences/AMB_Calm_Hiss.stop()
	$Ambiences/AMB_Storm_Noise.stop()
	$Ambiences/AMB_Storm_Droplets.stop()
	$Ambiences/AMB_Storm_Running.stop()
	$Music/MUS_Calm.stop()
	$Music/MUS_Storm.stop()
	
	#plays

	#Xero: You didn't unmute this, but I made a work around so you don't need to mute anymore
	#AudioServer.set_bus_mute(sfx_bus, true)
	$Music/MUS_Menu.play()
	$Ambiences/AMB_Storm_Noise.play()
	$Ambiences/AMB_Storm_Droplets.play()
func play_calm_mus():
	$Music/MUS_Menu.stop()
	$Music/MUS_Storm.stop()
	
	$Music/MUS_Calm.play()
	#$Music/MUS_Menu.play()
func play_storm_mus():
	$Music/MUS_Menu.stop()
	$Music/MUS_Calm.stop()
	
	$Music/MUS_Storm.play()
	
func play_menu_mus():
	$Music/MUS_Calm.stop()
	$Music/MUS_Storm.stop()
	
	$Music/MUS_Menu.play()
	$Ambiences/AMB_Storm_Noise.play()
	$Ambiences/AMB_Storm_Droplets.play()
	
func play_calm_amb():
	$Ambiences/AMB_Storm_Noise.stop()
	$Ambiences/AMB_Storm_Droplets.stop()
	$Ambiences/AMB_Storm_Running.stop()
	
	
	$Ambiences/AMB_Calm_Gulls.play()
	$Ambiences/AMB_Calm_Waves.play()
	$Ambiences/AMB_Calm_Hiss.play()

	

	
func play_storm_amb():
	$Ambiences/AMB_Calm_Gulls.stop()
	$Ambiences/AMB_Calm_Waves.stop()
	$Ambiences/AMB_Calm_Hiss.stop()
	
	
	$Ambiences/AMB_Storm_Noise.play()
	$Ambiences/AMB_Storm_Droplets.play()
	$Ambiences/AMB_Storm_Running.play()
	
#SFX

#Player
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
func play_collision_bonk():
	$SFX/Collision_Bonk.play()
	
func play_collision_splash():
	$SFX/Collision_Splash.play()

func play_collision(stream: AudioStream):
	$SFX/Game_Over.stream = stream
	$SFX/Game_Over.play()
	

#Storm
func play_thunder():
	$SFX/Thunder_Crack.play()

func play_distant_thunder():
	$SFX/Thunder_Rumble.play()
