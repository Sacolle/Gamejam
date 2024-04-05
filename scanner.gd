extends Area3D

@export
var step = 1

@export
var laser_base_scale = 10

@onready
var ray = $RayCast3D

@onready
var laser = $lazer

@onready
var anim = $AnimationPlayer

@onready 
var sound_player = $LazerHumPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	laser.visible = false
	anim.play("laser_on")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("scan"):
		sound_player.play()
	
	if Input.is_action_pressed("scan"):
		#anim.play("laser_on")
		laser.visible = true
		if ray.is_colliding():
			var c = ray.get_collider()
			var pos = c.position
			laser.scale.z  = (position.z - pos.z)/2
			laser.position.z = -(position.z - pos.z)/2
			#colidiu com o codigo de barra, se não o item n está sendo acertado
			if c.collision_layer == 2:
				c.hit()
			else:
				c.set_hit(false)
		else:
			laser.scale.z  = laser_base_scale
			laser.position.z = -laser_base_scale
	
	if Input.is_action_just_released("scan"):
		laser.visible = false
		sound_player.stop()
		get_tree().call_group("itens", "stopped_getting_hit")
	
	var old_pos = position.x
	# movimentação lateral do scaner
	if Input.is_action_just_pressed("left"):
		position.x -= step

	if Input.is_action_just_pressed("right"):
		position.x += step

	position.x = clamp(position.x, -2, 1)
	#if the lazer moved, let the items know that they are not getting hit
	if old_pos != position.x:
		get_tree().call_group("itens", "stopped_getting_hit")
