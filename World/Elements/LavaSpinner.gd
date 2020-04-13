extends Node2D

signal body_entered(body)

func _ready():
	$Timer.start()

func _on_Timer_timeout():
	self.rotate(0.1)


func _on_Lava_body_entered(body):
	self.emit_signal("body_entered", body)
