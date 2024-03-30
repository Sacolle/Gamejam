extends Area3D

signal item_scanned(value)

@export var time_to_scan = 2
@export var barcode_orientation = 0
@export var item_value = 1
@export var barcode_cell = Vector2i(0,0)
@export var rotation_speed = 0.5

var time: float = 0
var is_hit = false
var is_rotating = false

@onready var hit_box = $hitBox
@onready var point = $Center

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(pos):
	position = pos
	# pode ser a celula (1,0) ou (0, 0)
	#barcode_cell = Vector2(randi_range(0,1), 0)	
	barcode_orientation = randi_range(0, 3)

func step(amount):
	position += Vector3(0, 0, 1) * amount

func hit(scan_pos):
	is_hit = true

func stopped_getting_hit():
	is_hit = false

func set_item_center(cell: Vector2i) -> bool:
	if cell.x == position.x and cell.y == position.z: 
		return false
	var old_pos = Vector2(position.x, position.z)
	#puts the position at the cell
	position.x = cell.x
	position.z = cell.y
	
	#offsets the hitbox and mesh based on current orientation
	var orientation = current_orientation()
	var shape_dim = Vector2(hit_box.shape.size.x, hit_box.shape.size.z)
	match orientation:
		0: hit_box.position.x = float(old_pos.x - cell.x) / shape_dim.x
		1: hit_box.position.x = float(cell.y - old_pos.y) / shape_dim.x
		2: hit_box.position.x = float(cell.x - old_pos.x) / shape_dim.x #reversed 0
		3: hit_box.position.x = float(old_pos.y - cell.y) / shape_dim.x #reversed 1

	return true

func girar(amount: float):
	is_rotating = true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation:y", rotation.y + amount * (PI/2), rotation_speed)
	tween.tween_callback(is_not_rotating)
	
func is_not_rotating():
	is_rotating = false
	#reset the atributes

func current_orientation() -> int:
	return (int(rotation.y / (PI/2)) + 4) % 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_hit and barcode_orientation == current_orientation():
		time += delta
		if time > time_to_scan:
			item_scanned.emit(item_value)
			queue_free()
	else:
		time -= delta
		if time < 0:
			time = 0

@onready var left_ray = $hitBox/LeftRay
@onready var right_ray = $hitBox/RightRay
#
func is_rotation_valid(direction: int, changed_cell: bool) -> bool:
	#if the orientation is reversed, reversed the suposed direction
	#isso eh um hack fenomenal, mas fdc
	if changed_cell:
		var tmp = left_ray
		left_ray = right_ray
		right_ray = tmp
		
	if direction == 1:
		return not left_ray.is_colliding()
	else:
		return not right_ray.is_colliding()

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		var selected_cell = Grid.world_to_grid(position)
		print(position)
		print(selected_cell)
		if not is_rotating:
			var changed_cell = set_item_center(selected_cell)
			var dir = 1 if event.button_index == MOUSE_BUTTON_LEFT else -1 
			if is_rotation_valid(dir, changed_cell):
				girar(dir)
