extends Area3D

@export
var step = 1

@export
var laser_base_scale = 10

@onready
var ray = $RayCast3D

@onready
var laser = $lazer

# Called when the node enters the scene tree for the first time.
func _ready():
	laser.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("scan"):
		laser.visible = true
		if ray.is_colliding():
			var c = ray.get_collider()
			var pos = c.position
			laser.scale.z  = (position.z - pos.z)/2
			laser.position.z = -(position.z - pos.z)/2
			c.hit()
		else:
			laser.scale.z  = laser_base_scale
			laser.position.z = -laser_base_scale
	
	if Input.is_action_just_released("scan"):
		laser.visible = false
		get_tree().call_group("itens", "stopped_getting_hit")
	
	var old_pos = position.x
	# movimentação lateral do scaner
	if Input.is_action_just_pressed("left"):
		position.x -= step

	if Input.is_action_just_pressed("right"):
		position.x += step

	position.x = clamp(position.x, -1, 1)
	
	if old_pos != position.x:
		get_tree().call_group("itens", "stopped_getting_hit")
