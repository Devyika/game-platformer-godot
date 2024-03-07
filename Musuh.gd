extends KinematicBody2D

var gravitasi = 12
var kecepatan = Vector2.ZERO
var laju = 20
export var arah = 1

var apakah_terluka = false

onready var pivot = $pivot
onready var raycast = $pivot/RayCast2D

export var stamina = 3

func _ready():
	pass 

func _physics_process(delta):
	kecepatan.y += gravitasi
	
	if is_on_wall() or not raycast.is_colliding():
		arah = arah * -1
		pivot.scale.x = pivot.scale.x * -1
	
	kecepatan.x = laju * arah
	
	if not apakah_terluka:
		kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	if not apakah_terluka:
		_update_animasi()
	
func _update_animasi():
	if is_on_floor():
		$AnimatedSprite.play("Lari")
	else:
		$AnimatedSprite.play("jatuh")
	$AnimatedSprite.flip_h = true
	if arah == -1:
		$AnimatedSprite.flip_h = false


func _on_raisomeneng_body_entered(body):
	if body.name == 'HERO':
		body.terluka()


func _on_deteksiatas_body_entered(body):
	if body.name == "HERO" and not apakah_terluka and stamina > 0:
		body.kecepatan.y = -200
		terluka()
	
func terluka():
	stamina -= 1
	apakah_terluka = true
	$AnimatedSprite.play("terluka")
	yield(get_tree().create_timer(1), "timeout")
	print("STAMINA: ", stamina)
	if stamina <= 0: 
		mati()
	else:
		apakah_terluka = false

func mati():
	$AnimatedSprite.play("mati")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	$raisomeneng.set_collision_layer_bit(2, false)
	$raisomeneng.set_collision_mask_bit(0, false)
	$deteksiatas.set_collision_layer_bit(2, false)
	$deteksiatas.set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("menghilang")
	
func hapus():
	print("HAPUS!")
	queue_free()
