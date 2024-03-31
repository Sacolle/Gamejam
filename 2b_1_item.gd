extends Area3D

signal item_scanned(value)

@export var time_to_scan = 2
@export var item_value = 1
@export var rotation_speed = 0.5
@export var barcode_orientation = 0



var time: float = 0
var is_hit = false
#não usado
var is_rotating = false

@onready var hit_box = $hitBox
@onready var ray = $hitBox/CollisionRay
@onready var label = $TimeScanned
@onready var barcode = $hitBox/barCode

# Called when the node enters the scene tree for the first time.
func _ready():
	ray.add_exception(self)
	barcode.barcode_hit.connect(hit)
	pass # Replace with function body.

func start(pos):
	position = pos
	# pode ser a celula (1,0) ou (0, 0)
	#barcode_cell = Vector2(randi_range(0,1), 0)	

func step(amount):
	position += Vector3(0, 0, 1) * amount

func hit():
	if current_orientation() == barcode_orientation:
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
	label.text = str(time_to_scan - time)
	if is_hit:
		time += delta
		if time > time_to_scan:
			item_scanned.emit(item_value)
			queue_free()
	else:
		time -= delta
		if time < 0:
			time = 0


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("hey")
		var selected_cell = Grid.world_to_grid(position)
		#var local_cell = Grid.world_to_grid(position - self.position)
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
			var moved = true
			
			#gira o objeto
			rotation.y += dir * (PI/2)
			#força o update do raycast no msm frame
			ray.force_raycast_update()
			#se colidiu, desfaz a rotação
			#TODO: mostrar para o player, com alguma animação que a rotação falhou
			if ray.is_colliding():
				moved = false
				rotation.y = old_rotation
				
			#se o objeto girou, o barcode não está mais em contato com o laser
			if moved:
				is_hit = false

