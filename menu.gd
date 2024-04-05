extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_jogar_btn_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_carregar_btn_pressed():
	pass # TODO carregamento de save

func _on_opcoes_btn_pressed():
	pass # TODO interface de opcoes

func _on_sair_btn_pressed():
	get_tree().quit()
