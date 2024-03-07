extends Node2D 

onready var health_progress = $CanvasLayer/healtbar/TextureProgress
onready var jumlah_coin = $CanvasLayer/coinbar/Label

func _on_Zona_jatuh_body_entered(body):
	if body.name == 'HERO':
		get_tree().change_scene("res://level 1.tscn")


func _on_HERO_hero_apdet_coin(value):
	jumlah_coin.text = String(value)


func _on_HERO_hero_apdet_health(value):
	health_progress.value = value
