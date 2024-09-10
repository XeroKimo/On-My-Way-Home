extends Node2D

var spawnPos = Vector2()

var rock = preload("res://Obstacles/rock.tscn")
var balloon = preload("res://Obstacles/Balloon.tscn")
@onready var player = $"../CameraTest"

var spawnable = [rock, balloon] # the array of spawnable obstacles

func _ready():
	randomize() # to get a need seed of randomness for the position
	
	


func _on_random_spawn_timeout():
	spawnPos = Vector2(player.position.x + 960, randf_range(280,1080))
	
	var spawn = spawnable[randi()%spawnable.size()].instantiate()
	add_child(spawn)
	spawn.global_position = spawnPos
	
	$"../RandomSpawn".start()
