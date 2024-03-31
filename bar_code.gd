extends Area3D

signal barcode_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit():
	barcode_hit.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
