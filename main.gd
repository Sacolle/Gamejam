extends Node3D
@export
var current_level: Level = null;

var item_scene = preload("res://item.tscn")

var spawn = true
var step = true

var score = 0

var items = {
	"1b1": preload("res://1b_1_item.tscn"),
	"2b1": preload("res://2b_1_item.tscn")
}

var time = 0

var live_items = 0
var finished_spawning: bool = false

signal level_ended(score: int)

signal defeat(score: int)


# Called when the node enters the scene tree for the first time.
func _ready():
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
		if current_level.spawns.size() > time:
			var will_spawn = current_level.spawns[time]
			if will_spawn:
				var item : BaseItem = items[will_spawn.id].instantiate()
				get_tree().root.add_child(item)
				item.start(Vector3(will_spawn.position.x,0, will_spawn.position.y), will_spawn.time_to_scan, will_spawn.points)
				item.rotation.y += will_spawn.orientation * (PI/2)
				item.item_scanned.connect(_on_item_scanned)
				live_items += 1
			time += 1;
			if current_level.spawns.size() <= time:
				finished_spawning = true
#			TODO: check here if all items have been scanned and passed to the next level
		
		
		#var item = item_scene.instantiate()
		#get_tree().root.add_child(item)
		#item.start(Vector3(randi_range(-1, 1), 0, 0))
		#item.item_scanned.connect(_on_item_scanned)

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
