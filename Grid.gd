class_name Grid


const CELL_SIZE = 1

static func world_to_grid(pos: Vector3) -> Vector2i:
	var a = ((pos + Vector3(0.5,0,0.5)) / CELL_SIZE).floor()
	return Vector2i(a.x, a.z)
