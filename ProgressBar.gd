@tool
extends Node3D

class_name FloatingProgressBar

@export
var value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$SubViewport/Node2D/TextureProgressBar.value = value

