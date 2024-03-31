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

enum Collision { waiting, yes, no }

var collided: Collision = Collision.no

@onready var hit_box = $hitBox
@onready var ray = $hitBox/CollisionRay

# Called when the node enters the scene tree for the first time.
func _ready():
	ray.add_exception(self)
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

	position.x = cell.x
	position.z = cell.y
	
	#offsets the hitbox and mesh based on current orientation
	var orientation = current_orientation()
	var shape_dim = Vector2(hit_box.shape.size.x, hit_box.shape.size.z)
	var offset = 0
	match orientation:
		0: offset = float(old_pos.x - cell.x)
		1: offset = float(cell.y - old_pos.y)
		2: offset = float(cell.x - old_pos.x) #reversed 0
		3: offset = float(old_pos.y - cell.y) #reversed 1
	
	hit_box.position.x = offset / shape_dim.x
	
	#print("hitbox offset:", hit_box.position)
	#print('')
	return true

"""
func girar(amount: float):
	is_rotating = true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation:y", rotation.y + amount * (PI/2), rotation_speed)
	tween.tween_callback(is_not_rotating)
	
func is_not_rotating():
	is_rotating = false
	#reset the atributes
"""

func current_orientation() -> int:
	return (int(round(rotation.y / (PI/2))) + 4) % 4

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

#
func is_rotation_valid(direction: int) -> bool:
	#ray.position = position
	ray.rotation.y += direction * (PI/2)
	ray.force_raycast_update()
	var is_colliding = ray.is_colliding()
	ray.rotation.y = 0
	return not is_colliding



func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var selected_cell = Grid.world_to_grid(position)
		var local_cell = Grid.world_to_grid(position - self.position)
		"""
		if not (local_cell.x == 0 and local_cell.y == 0):
			print("posição", position)
			print("celula selecionada", selected_cell)
			print("Local", local_cell)
			print("orientação:", current_orientation())
			print("rotação: ", (rotation.y / PI) * 180)
		"""
		if not is_rotating:
			var changed_cell = set_item_center(selected_cell)
			var dir = 1 if event.button_index == MOUSE_BUTTON_LEFT else -1 
			var old_rotation = rotation.y 
			
			#jeito mais mongol de se fazer, mas fazer oq
			rotation.y += dir * (PI/2)
			ray.force_raycast_update()
			if ray.is_colliding():
				rotation.y = old_rotation

