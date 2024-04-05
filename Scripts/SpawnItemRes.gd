extends Resource
class_name SpawnItem

@export_enum("coca", "guarana", "monster", "succ", "milk", "beans", "aipo")
var id: String
@export
var position: Vector2i = Vector2i(0,-3)
@export_range(0,3)
var orientation: int = 2
@export
var time_to_scan: float = 1.0

@export
var points : int = 1
