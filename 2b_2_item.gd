extends BaseItem

func _ready():
	barcode = $hitBox/barCode
	collision_detector = $hitBox/collisionDetection
	hit_box = $hitBox
	super()
