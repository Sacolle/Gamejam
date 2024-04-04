extends MeshInstance3D


@onready var anim_player = $AnimationPlayer
#var is_selected = true

func _ready():
	#anim_player.stop()
	visible = false

func show_selected_cell():
	get_tree().call_group("highlight_cell", "hide_selected_cell")
	visible = true
	#anim_player.play("show")

func hide_selected_cell():
	visible = false
	#anim_player.stop()

	
	
