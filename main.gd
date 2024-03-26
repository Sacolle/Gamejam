extends Node3D

var item_scene = preload("res://item.tscn")

var spawn = true
var step = true

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$spawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#spawn_enemies()
	#step_enemies()
	$Camera3D/ScoreLabel.text = "Score: " + str(score)
	
func spawn_enemies():
	if spawn:
		spawn = false
		$spawnTimer.start()
		var item = item_scene.instantiate()
		get_tree().root.add_child(item)
		item.start(Vector3(randi_range(-1, 1), 0, 0))
		item.item_scanned.connect(_on_item_scanned)

func _on_item_scanned(amount):
	score += amount

func step_enemies():
	if step:
		get_tree().call_group("itens", "step", 1)
		step = false
		$stepTimer.start()

func _on_spawn_timer_timeout():
	spawn = true


func _on_step_timer_timeout():
	step = true
