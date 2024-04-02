extends Node3D

class_name CollisionDetector

var rays: Array[RayCast3D] 

func _ready():
	for c in self.get_children():
		if c is RayCast3D:
			rays.push_back(c)
			c.add_exception(c.get_owner())

func is_colliding() -> bool:
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			return true		
	return false
