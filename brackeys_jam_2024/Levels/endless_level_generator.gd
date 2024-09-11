extends Node2D

@export var background: PackedScene
@export var obstacles: Array
@onready var lanes = [$"Lane 1", $"Lane 2", $"Lane 3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var child = background.instantiate() as EndlessLevelPart
	add_child(child)
	child.initialize([(lanes[0] as Node2D).position, (lanes[1] as Node2D).position, (lanes[2] as Node2D).position], obstacles, Array())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
