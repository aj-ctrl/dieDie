extends Sprite2D

@onready var anim = $AnimationPlayer
var value

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("fade_in")
	
	value = (randi() % 6) + 1
	frame = value - 1
	print(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func kill():
	queue_free()
