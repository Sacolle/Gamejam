extends Resource
class_name Level

@export var id: int = 0
@export
var title: String;
@export
var spawns: Array[SpawnItem] = [];

@export
var next_level: Level = null
