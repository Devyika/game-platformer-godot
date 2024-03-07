extends Area2D

func _on_coin_body_entered(body):
	if body.name == 'HERO':
		body.ambil_koin()
		
#	remove_from_group("grupkoin")
#	if body.name == 'HERO':
#		body.ambil_koin()
	
	queue_free()
