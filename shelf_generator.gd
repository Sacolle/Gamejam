@tool
extends Node3D

var shelf = preload('res://components/shelf.tscn')

@export
var amount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in amount:
		var s = shelf.instantiate()
		add_child(s)
		s.position = Vector3(i, 0, 0)
		#print(s)
