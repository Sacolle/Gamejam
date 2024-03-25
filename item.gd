extends Area3D

signal item_scanned(value)

@export
var time_to_scan = 2
@export
var barcode_face = 0

var time: float = 0
var is_hit = false
var is_rotating = false

@onready
var label = $TimeScanned

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(pos):
	position = pos
	barcode_face = randi_range(0, 3)

func step(amount):
	position += Vector3(0, 0, 1) * amount

func hit():
	is_hit = true

func is_not_rotating():
	is_rotating = false

func girar(amount: float):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation:y", rotation.y + amount * (PI/2), 0.5)
	tween.tween_callback(is_not_rotating)
	await tween.finished


func stopped_getting_hit():
	is_hit = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(time_to_scan - time)
	var side = (int(rotation.y / (PI/2)) + 4) % 4 
	if is_hit and barcode_face == side:
		time += delta
		if time > time_to_scan:
			item_scanned.emit(1)
			queue_free()
	else:
		time -= delta
		if time < 0:
			time = 0


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		#print(position)
		print(Grid.world_to_grid(position))
		if not is_rotating:
			is_rotating = true
			if event.button_index == MOUSE_BUTTON_LEFT:
				girar(1)
			else:
				girar(-1)
		
