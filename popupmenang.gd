extends CenterContainer

onready var tween = $Tween

var sudah_muncul = false

func _ready():
	pass
	
func muncul():
	tween.interpolate_property(self, "rect_position:y", -130, 56, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func _on_HERO_hero_menang():
	if not sudah_muncul:
		sudah_muncul = true
		muncul()

func _on_selanjutnya_pressed():
	get_tree().change_scene("res://level 2.tscn")
