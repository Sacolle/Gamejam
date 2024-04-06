extends Node3D
@export
var current_level: Level = null;

var spawn = true
var step = true

var score = 0

var items = {
	#1b1
	"coca": preload("res://itens/coca.tscn"),
	"guarana": preload("res://itens/guarana.tscn"),
	"monster": preload("res://itens/monster.tscn"),
	#2b1
	"succ": preload("res://itens/succ.tscn"),
	#2b2
	"milk": preload("res://itens/milk.tscn"),
	"beans": preload("res://itens/beans.tscn"),
	#3b1
	"aipo": preload("res://itens/aipo.tscn")
}

var time_to_scan_table = {
	"coca": 1,
	"guarana": 1,
	"monster": 1,
	#2b1
	"succ": 1.5,
	#2b2
	"milk": 2,
	"beans": 2,
	#3b1
	"aipo": 3
}

var points_table = {
	"coca": 1,
	"guarana": 1,
	"monster": 1.5,
	#2b1
	"succ": 2,
	#2b2
	"milk": 3,
	"beans": 3,
	#3b1
	"aipo": 5
}


var inimigos = {
	"cat": preload("res://assets/sprites/meowafinal_1.png"),
	"dog": preload("res://assets/sprites/doggyfinal.png"),
	"zaf": preload("res://assets/sprites/zaffinofinal_1.png")
}

var time = 0

var live_items = 0
var finished_spawning: bool = false

signal level_ended(score: int)
signal game_cleared(score: int)

signal defeat(score: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySprite.texture = inimigos[current_level.enemy]
	$spawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	spawn_enemies()
	step_enemies()
	$Camera3D/ScoreLabel.text = "Score: " + str(score)
	
func spawn_enemies():
	if spawn:
		spawn = false
		$spawnTimer.start()
		instantiate_enemy()

func instantiate_enemy():
	if current_level.spawns.size() > time:
		var will_spawn = current_level.spawns[time]
		if not will_spawn:
			time += 1
			return 
		
		var item : BaseItem = items[will_spawn.id].instantiate()
		get_tree().root.add_child(item)
		item.start(
			Vector3(will_spawn.position.x, 0, will_spawn.position.y), 
			time_to_scan_table[will_spawn.id], 
			points_table[will_spawn.id]
		)
		item.rotation.y += will_spawn.orientation * (PI/2)
		item.item_scanned.connect(_on_item_scanned)
		live_items += 1
		time += 1;
		if will_spawn.immediate_next:
			instantiate_enemy()
	else:
		finished_spawning = true

func _on_item_scanned(amount):
	live_items -= 1
	score += amount

	#not playing in this current scene, because the itens did not spawn via the spawner
	#therefore they did not have their signals connected,
	$ItemCheckedSfx.play()

	if live_items <= 0:
	#TODO: Maybe give a bonus score if all items are clear?
		if finished_spawning:
			level_ended.emit(score)


func step_enemies():
	if step:
		$BeltStepSfx.play()
		get_tree().call_group("itens", "step", 1)
		step = false
		$stepTimer.start()

func _on_spawn_timer_timeout():
	spawn = true


func _on_step_timer_timeout():
	step = true


func _on_kill_box_area_entered(area):
	#TODO: the game over
	print("game over")
	area.queue_free()
	get_tree().change_scene_to_file("res://game_over_menu.tscn")

func _on_level_ended(score):
	if (current_level.next_level):
		# The game continues
		print("Going to next level!")
		current_level = current_level.next_level
		$EnemySprite.texture = inimigos[current_level.enemy]
		time = 0
		live_items = 0
		finished_spawning = false
	else:
		game_cleared.emit(score)
		print("Last level cleared!!")
