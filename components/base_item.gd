extends Area3D

class_name BaseItem

signal item_scanned(value)

@export var time_to_scan = 2
@export var item_value = 1

var hit_box: CollisionShape3D
var collision_detector: CollisionDetector
#TODO: add the correct label scene
#@export var label
var barcode: Barcode

#private variables
var time: float = 0
var is_hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(hit_box != null)
	assert(collision_detector != null)
	assert(barcode != null)
	#conecta ao sinal de colisão do barcode
	barcode.barcode_hit.connect(hit)

func start(pos: Vector3, _time_to_scan: float = 2, _item_value: float = 1):
	position = pos
	time_to_scan = _time_to_scan
	item_value = _item_value

func step(amount):
	position += Vector3(0, 0, 1) * amount

func hit():
	is_hit = true
func stopped_getting_hit():
	is_hit = false
func set_hit(h: bool):
	is_hit = h

#TODO: bug fix do 2x2, descobrir pq ele centraliza, pode ser:
#	- na current orientation
#	- no set_item_center, no calculo do offset para o eixo z

func set_item_center(cell: Vector2i) -> bool:
	if cell.x == position.x and cell.y == position.z: 
		return false
	var old_pos = Vector2(position.x, position.z)

	position.x = cell.x
	position.z = cell.y
	
	#offsets the hitbox and mesh based on current orientation
	var orientation = current_orientation()
	var offset = Vector2(0,0)
	match orientation:
		0: offset = Vector2(old_pos.x - cell.x, old_pos.y - cell.y)
		1: offset = Vector2(cell.y - old_pos.y, cell.x - old_pos.x)
		2: offset = Vector2(cell.x - old_pos.x, cell.y - old_pos.y) #reversed 0
		3: offset = Vector2(old_pos.y - cell.y, old_pos.x - cell.x) #reversed 1

	var shape_dim = Vector2(hit_box.shape.size.x, hit_box.shape.size.z)
	print("shape_dim ", shape_dim)
	
	hit_box.position.x = offset.x / shape_dim.x
	hit_box.position.z = offset.y / shape_dim.y

	return true

func current_orientation() -> int:
	return (int(round(rotation.y / (PI/2))) + 4) % 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#label.text = str(time_to_scan - time)
	if is_hit:
		time += delta
		if time > time_to_scan:
			item_scanned.emit(item_value)
			queue_free()
	else:
		time -= delta
		if time < 0:
			time = 0

func _on_input_event(_camera, event, pos, _normal, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var selected_cell = Grid.world_to_grid(pos)
		#if processed_collision:
		var _changed_cell = set_item_center(selected_cell)
		var dir = 1 if event.button_index == MOUSE_BUTTON_LEFT else -1 
		#gira o objeto
		var old_rotation = rotation
		rotation.y += dir * (PI/2)
		if collision_detector.is_colliding():
			rotation = old_rotation
