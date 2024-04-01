extends Area3D

signal item_scanned(value)

@export var time_to_scan = 2
@export var barcode_orientation = 0
@export var item_value = 1
@export var barcode_cell = Vector2(0,0)
@export var rotation_speed = 0.5

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
	barcode_orientation = randi_range(0, 3)

func step(amount):
	position += Vector3(0, 0, 1) * amount

func hit():
	is_hit = true

func stopped_getting_hit():
	is_hit = false

func girar(amount: float):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation:y", rotation.y + amount * (PI/2), rotation_speed)
	tween.tween_callback(is_not_rotating)
	await tween.finished

func is_not_rotating():
	is_rotating = false

func current_orientation() -> int:
	return (int(rotation.y / (PI/2)) + 4) % 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(time_to_scan - time)
	if is_hit and barcode_orientation == current_orientation():
		time += delta
		if time > time_to_scan:
			item_scanned.emit(item_value)
			queue_free()
	else:
		time -= delta
		if time < 0:
			time = 0

func _on_input_event(_camera, event, pos, _normal, _shape_idx):
	if event is InputEventMouseButton:
		#print(position)
		print(Grid.world_to_grid(pos))
		if not is_rotating:
			is_rotating = true
			if event.button_index == MOUSE_BUTTON_LEFT:
				girar(1)
			else:
				girar(-1)
		
