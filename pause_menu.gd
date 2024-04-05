extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = !visible
		print(get_tree().paused)

func _on_continuar_btn_pressed():
	visible = !visible
	get_tree().paused = !visible
	
func _on_salvar_btn_pressed():
	pass # Replace with function body.

func _on_opcoes_btn_pressed():
	pass # TODO interface de opcoes

func _on_sair_btn_pressed():
	get_tree().quit()





