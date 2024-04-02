class_name Grid

const CELL_SIZE = 1

const CELL_OFFSET: Vector3 = Vector3(0.5,0,0.5)

static func world_to_grid(pos: Vector3) -> Vector2i:
	var a = ((pos + CELL_OFFSET) / CELL_SIZE).floor()
	return Vector2i(a.x, a.z)
