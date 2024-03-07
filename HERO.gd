extends KinematicBody2D

var laju_cepat = 300
var laju_normal = 120
var laju = laju_normal
var kecepatan = Vector2.ZERO
var laju_lompat = -300
var gravitasi = 12
var coin = 0
var sedang_terluka = false
var health_maks = 50
var health = 50
onready var sprite = $Sprite

signal hero_mati
signal hero_menang
signal hero_apdet_health(value)
signal hero_apdet_coin(value)

func _physics_process(delta):
	kecepatan.y = kecepatan.y + gravitasi
	
	
	if(not sedang_terluka and Input.is_action_pressed("gerak kanan")):
		kecepatan.x = laju
		$Sprite.flip_h = false
	if(not sedang_terluka and Input.is_action_pressed("gerak kiri")):
		kecepatan.x = -laju
		$Sprite.flip_h = true
	
	if(not sedang_terluka and Input.is_action_pressed("lari_cepat")):
		lari_cepat()
	
	if(not sedang_terluka and Input.is_action_pressed("lompat") and is_on_floor()):
		kecepatan.y = laju_lompat
	
	#print(kecepatan.y)
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	if not sedang_terluka:
		update_animasi()

func update_animasi():
	if is_on_floor():
		if kecepatan.x < (laju * 0.5) and kecepatan.x > (-laju * 0.5):
			sprite.play("diam")
		else:
			if laju == laju_normal:
				sprite.play("berlari")
			elif laju == laju_cepat:
				sprite.play("laricepat")
	else:
		if kecepatan.y > 0:
			#jatuh
			sprite.play("jatuh")
		else:
			#lompat
			sprite.play("lompat")
	

func lari_cepat():
	laju = laju_cepat
	$Timer.start()

func _on_Timer_timeout():
	laju = laju_normal


func ambil_koin():
	coin = coin + 1
#	print(" coin: ", coin)
	emit_signal("hero_apdet_coin", coin)
	#cek jumlah koin, jika habis panggil hero_menang
	var grup_koin = get_tree().get_nodes_in_group("grupkoin")
	var jumlah_koin = grup_koin.size()
	print("Grup koin: ", grup_koin)
	print("Jumlah: ", jumlah_koin)
	if jumlah_koin == 1:
		emit_signal("hero_menang")

func terluka():
	sedang_terluka = true
	
	
	health -= 15
	emit_signal("hero_apdet_health", (float(health)/float(health_maks)) * 100)
	
	if kecepatan.x > 0:
		kecepatan.x = -500
	else:
		kecepatan.x = 500
	
	sprite.play("terluka")
	yield(get_tree().create_timer(1), "timeout")
	
	if health <= 0:
		mati()
	else:
		sedang_terluka = false

func mati():
	sprite.play("mati")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(2, false)
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("hero_mati")
#	emit_signal("hero_menang")
#	get_tree().change_scene("res://level 1.tscn")

