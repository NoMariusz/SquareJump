extends Node2D
var cycles_until_change_direction = 20
var direcion_down = true
signal body_entered(body)

func _ready():
	$Timer.start()


func _on_Timer_timeout():
	if self.cycles_until_change_direction <= 0:
		self.cycles_until_change_direction = 20
		self.direcion_down = not self.direcion_down
	else:
		self.cycles_until_change_direction -= 1
		if self.direcion_down:
			$Lava.move_local_y(10)
		else:
			$Lava.move_local_y(-10)


func _on_Lava_body_entered(body):
	self.emit_signal("body_entered", body)
